import asyncHandler from '../../../middleware/asyncHandler.js'
import UserTrackerLog from '../../../models/UserTrackerLog.js';

/**
 * GET /api/v1/usertrackerlogs/:trackerId
 * Тухайн tracker-д холбогдсон бүх лог буцаана
 */
export const getLogsByTracker = asyncHandler(async (req, res) => {
    const { trackerId } = req.params;

    const logs = await UserTrackerLog.find({ tracker: trackerId })
        .sort({ received_date: -1 }) // хамгийн сүүлд ирсэн дата эхэнд
        .lean();

    return req.sendData(logs);
});
