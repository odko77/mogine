import express from "express";
const router = express.Router();

import { createPoint
        ,readPoints
        ,readPoint
        ,updatePoint
        ,deletePoint
} from '../../controller/geo/border/index.js'
import loginRequired from "../../middleware/loginRequired.js";

router.post("/point-name", loginRequired, createPoint)
router.get("/point-name", loginRequired, readPoints)
router.get("/point-name/detail/:id", readPoint)
router.put("/point-name/:id", updatePoint)
router.delete("/point-name/:id", deletePoint)

export default router
