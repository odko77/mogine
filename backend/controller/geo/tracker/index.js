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

    const ts = trackers.map(
        (t) => {
            t.imageUrl = process.env.PUBLIC_HOST + t.imageUrl
            return t
        }
    )

    return req.sendData(ts)
})
