import asyncHandler from "../../../middleware/asyncHandler.js";
import Tracker from "../../../models/Tracker.js";

export const getTrackers = asyncHandler(async (req, res) => {
    const trackers = await Tracker.find({})
    return req.sendData(trackers)
})
