import Tracker from "../../../models/Tracker.js";
import UserTracker from "../../../models/UserTracker.js";
import asyncHandler from '../../../middleware/asyncHandler.js'


/**
 * GET /api/v1/usertrackers
 * Бүх active UserTracker-ийг map view-д зориулж буцаана
 * Response: { userId, userName, trackerId, trackerName, location, battery, trackertype }
 */
export const getUserTrackersMap = asyncHandler(async (req, res) => {

    const userTrackers = await UserTracker.find({ state: "ACTIVE", user: req.userId })
        .populate("user", "name email") // user info
        .populate("tracker", "name imei") // tracker info
        .lean();

    const mapData = userTrackers.map(ut => ({
        userId: ut.user._id,
        trackerId: ut.tracker._id,
        name: ut.name || ut.tracker.name,
        last_data: ut.last_data,
        trackertype: ut.trackertype || ut.custom_trackertype || null,
        updatedAt: ut.updatedAt,
    }));

    return req.sendData(mapData);
});

/**
 * POST /trackers/:trackerId/usertrackers
 * Тухайн tracker-д хэрэглэгч холбож UserTracker үүсгэх
 * body: { userId, freq, sub_end_date, trackertype, custom_trackertype }
 */
/**
 * POST /trackers/:trackerId/usertrackers
 * Тухайн tracker-д хэрэглэгч холбож UserTracker үүсгэх
 * body: { freq, sub_end_date, trackertype, custom_trackertype, name }
 * file: image
 */
export const addUserTracker = asyncHandler(async (req, res) => {
    const userId = req.userId;
    const { imei, freq, sub_end_date, trackertype, custom_trackertype, name } = req.body;

    const tracker = await Tracker.findOne({ imei: imei });
    if (!tracker) {
        return res.status(404).json({ success: false, error: "Tracker not found" });
    }

    const a = await UserTracker.findOne({
        user: userId,
        tracker: tracker._id,
        state: "ACTIVE"
    });

    if (a) {
        return req.sendInfo("INF_001");
    }

    let imageUrl = null;

    if (req.file) {
        imageUrl = `/uploads/usertrackers/${req.file.filename}`;
    }

    const userTracker = await UserTracker.create({
        name,
        imageUrl,
        tracker: tracker._id,
        user: userId,
        freq,
        sub_end_date,
        trackertype,
        custom_trackertype
    });

    return req.sendData(userTracker);
});
