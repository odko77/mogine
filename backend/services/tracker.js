import Tracker from "../models/Tracker.js";
import UserTracker from "../models/UserTracker.js";
import UserTrackerLog from "../models/UserTrackerLog.js";

/**
 * MQTT-ээр ирсэн дата боловсруулна:
 * - imei-тэй tracker байхгүй бол шинэ tracker үүсгэнэ (version: "1")
 * - active UserTracker байвал UserTrackerLog үүсгэнэ
 * - Duplicate log үүсгэхээс сэргийлнэ
 *
 * @param {Object} payload - MQTT payload
 * @param {number|string} payload.imei
 * @param {number} payload.lat
 * @param {number} payload.lon
 * @param {number} payload.tst - Unix timestamp
 * @param {number} [payload.alt]
 * @param {number} [payload.vel]
 * @param {number} [payload.vbat]
 * @param {number} [payload.vbat_v]
 * @param {number} [payload.temp]
 * @param {number} [payload.batt]
 */
export async function processMqttPayload(payload) {
  const { imei, lat, lon, tst, vel = 0, batt = 0 } = payload;
  const imeiStr = String(imei);

  // Tracker хайж олох, байхгүй бол үүсгэх
  let tracker = await Tracker.findOne({ imei: imeiStr });
  if (!tracker) {
    tracker = await Tracker.create({
      imei: imeiStr,
      version: "1",
    });
  }

  // Active UserTracker-г хайна
  const activeUserTrackers = await UserTracker.find({
    tracker: tracker._id,
    state: "ACTIVE",
  });

  if (activeUserTrackers.length === 0) {
    return { tracker, logCreated: false };
  }

  // Duplicate check
  let shouldCreateLog = false;
  for (const userTracker of activeUserTrackers) {
    const last = userTracker.last_data;
    if (!last) {
      shouldCreateLog = true;
      break;
    }

    const locationChanged = last.lat !== lat || last.lon !== lon;
    const batteryChanged = last.batt !== batt;
    const velocityChanged = last.vel !== vel;

    if (locationChanged || batteryChanged || velocityChanged) {
      shouldCreateLog = true;
      break;
    }
  }

  if (!shouldCreateLog) {
    return { tracker, logCreated: false };
  }

  // Log үүсгэх
  const receivedDate = tst ? new Date(tst * 1000) : new Date();

  const logData = {
    tracker: tracker._id,
    location: { type: "Point", coordinates: [lon, lat] },
    imei: imeiStr,
    lat,
    lon,
    tst,
    alt: payload.alt,
    vel,
    vbat: payload.vbat,
    vbat_v: payload.vbat_v,
    temp: payload.temp,
    batt,
    received_date: receivedDate,
  };

  await UserTrackerLog.create(logData);

  // Last data-г update
  const lastData = {
    location: { type: "Point", coordinates: [lon, lat] },
    imei: imeiStr,
    lat,
    lon,
    tst,
    alt: payload.alt,
    vel,
    vbat: payload.vbat,
    vbat_v: payload.vbat_v,
    temp: payload.temp,
    batt,
  };

  await UserTracker.updateMany(
    { tracker: tracker._id, state: "ACTIVE" },
    { last_data: lastData }
  );

  return { tracker, logCreated: true };
}
