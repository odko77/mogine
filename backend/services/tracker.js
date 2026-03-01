import Tracker from "../models/Tracker.js";
import UserTracker from "../models/UserTracker.js";
import UserTrackerLog from "../models/UserTrackerLog.js";
import TrackerBorder from "../models/TrackerBorder.js";

class TrackerService {
  /**
   * MQTT payload боловсруулах
   */
  async processPayload(payload) {
    const { imei, lat, lon, tst, vel = 0, batt = 0 } = payload;
    const imeiStr = String(imei);

    if (!imeiStr || lat == null || lon == null) {
      return { success: false, message: "Invalid payload" };
    }

    // 1️⃣ Tracker find / create
    const tracker = await this.findOrCreateTracker(imeiStr);

    // 2️⃣ Active userTracker-ууд авах
    const activeUserTrackers = await UserTracker.find({
      tracker: tracker._id,
      state: "ACTIVE",
    });

    if (activeUserTrackers.length === 0) {
      return { success: true, tracker, logCreated: false };
    }

    // 3️⃣ Duplicate шалгах
    const shouldCreate = this.shouldCreateLog(
      activeUserTrackers,
      payload
    );

    if (!shouldCreate) {
      return { success: true, tracker, logCreated: false };
    }

    // 4️⃣ Geofence event шалгах
    let geofenceEvent = null;
    let borderId = null;

    for (const userTracker of activeUserTrackers) {
      const result = await this.checkGeofence(
        userTracker,
        lat,
        lon
      );

      if (result.event) {
        geofenceEvent = result.event;
        borderId = result.border?._id || null;
        break;
      }
    }

    // 5️⃣ Log үүсгэх
    await this.createLog(tracker, payload, geofenceEvent, borderId);

    // 6️⃣ last_data update
    await this.updateLastData(tracker._id, payload);

    return {
      success: true,
      tracker,
      logCreated: true,
      event: geofenceEvent,
    };
  }

  // ===============================
  // Tracker
  // ===============================

  async findOrCreateTracker(imei) {
    let tracker = await Tracker.findOne({ imei });

    if (!tracker) {
      tracker = await Tracker.create({
        imei,
        version: "1",
      });
    }

    return tracker;
  }

  // ===============================
  // Duplicate шалгалт
  // ===============================

  shouldCreateLog(activeUserTrackers, payload) {
    const { lat, lon, vel = 0, batt = 0 } = payload;

    for (const userTracker of activeUserTrackers) {
      const last = userTracker.last_data;

      if (!last) return true;

      const locationChanged =
        last.lat !== lat || last.lon !== lon;

      const batteryChanged = last.batt !== batt;
      const velocityChanged = last.vel !== vel;

      if (locationChanged || batteryChanged || velocityChanged) {
        return true;
      }
    }

    return false;
  }

  // ===============================
  // Geofence шалгалт
  // ===============================

  async checkGeofence(userTracker, lat, lon) {
    const point = {
      type: "Point",
      coordinates: [lon, lat], // ⚠️ lng, lat
    };

    // Одоо polygon дотор байна уу?
    const bordersNow = await TrackerBorder.find({
      userTrackers: userTracker._id,
      polygon: {
        $geoIntersects: {
          $geometry: point,
        },
      },
    });

    const isInsideNow = bordersNow.length > 0;

    let wasInsideBefore = false;

    if (userTracker.last_data?.lat && userTracker.last_data?.lon) {
      const lastPoint = {
        type: "Point",
        coordinates: [
          userTracker.last_data.lon,
          userTracker.last_data.lat,
        ],
      };

      const bordersBefore = await TrackerBorder.find({
        userTrackers: userTracker._id,
        polygon: {
          $geoIntersects: {
            $geometry: lastPoint,
          },
        },
      });

      wasInsideBefore = bordersBefore.length > 0;
    }

    if (wasInsideBefore && !isInsideNow) {
      return { event: "EXIT", border: null };
    }

    if (!wasInsideBefore && isInsideNow) {
      return { event: "ENTER", border: bordersNow[0] };
    }

    return { event: null };
  }

  // ===============================
  // Log үүсгэх
  // ===============================

  async createLog(tracker, payload, event, borderId) {
    const receivedDate = payload.tst
      ? new Date(payload.tst * 1000)
      : new Date();

    const logData = {
      tracker: tracker._id,
      location: {
        type: "Point",
        coordinates: [payload.lon, payload.lat],
      },
      imei: String(payload.imei),
      lat: payload.lat,
      lon: payload.lon,
      tst: payload.tst,
      alt: payload.alt,
      vel: payload.vel ?? 0,
      vbat: payload.vbat,
      vbat_v: payload.vbat_v,
      temp: payload.temp,
      batt: payload.batt ?? 0,
      received_date: receivedDate,

      // 🔥 Geofence event
      event: event,
      border: borderId,
    };

    await UserTrackerLog.create(logData);
  }

  // ===============================
  // last_data update
  // ===============================

  async updateLastData(trackerId, payload) {
    const lastData = {
      location: {
        type: "Point",
        coordinates: [payload.lon, payload.lat],
      },
      imei: String(payload.imei),
      lat: payload.lat,
      lon: payload.lon,
      tst: payload.tst,
      alt: payload.alt,
      vel: payload.vel ?? 0,
      vbat: payload.vbat,
      vbat_v: payload.vbat_v,
      temp: payload.temp,
      batt: payload.batt ?? 0,
    };

    await UserTracker.updateMany(
      { tracker: trackerId, state: "ACTIVE" },
      { last_data: lastData }
    );
  }
}

export default new TrackerService();
