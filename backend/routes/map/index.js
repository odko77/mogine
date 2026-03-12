import express from "express";
const router = express.Router();

import { createPoint
        ,readPoints
        ,readPoint
        ,updatePoint
        ,deletePoint
} from '../../controller/geo/point-names/index.js'

import { getUserTrackersMap, addUserTracker } from "../../controller/geo/user-tracker/index.js";

import { getLastTrackers, getTrackers } from '../../controller/geo/tracker/index.js'

import { getLogsByTracker } from "../../controller/geo/user-tracker-log/index.js";

import loginRequired from "../../middleware/loginRequired.js";

import upload from '../../middleware/upload.js'

router.post("/point-name", loginRequired, createPoint)
router.get("/point-name", loginRequired, readPoints)
router.get("/point-name/detail/:id", readPoint)
router.put("/point-name/:id", updatePoint)
router.delete("/point-name/:id", deletePoint)

router.get("/user-tracker", loginRequired, getUserTrackersMap);
router.post("/user-tracker", loginRequired, upload.single('image'), addUserTracker);

router.route("/user-tracker-log/:trackerId")
        .get(loginRequired, getLogsByTracker)

router.route("/tracker")
        .get(getTrackers)

router.route("/latest-recieved-trackers").get(loginRequired, getLastTrackers)

export default router
