import asyncHandler from "../../../middleware/asyncHandler.js";
import Tracker from "../../../models/Tracker.js";
import UserTracker from "../../../models/UserTracker.js";

export const getTrackers = asyncHandler(async (req, res) => {
    const trackers = await Tracker.find({})
    return req.sendData(trackers)
})

export const getLastTrackers = asyncHandler(async (req, res) => {
    const trackers = await UserTracker.find({
        user: req.userId,
        state: "ACTIVE"
      })
        .populate("tracker")
        .sort({ lastReceiveDate: -1 })
    return req.sendData(trackers)
})
