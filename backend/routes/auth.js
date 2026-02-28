import express from "express"
import { login, verify, me } from "../controller/auth/index.js"
import loginRequired from "../middleware/loginRequired.js"
import asyncHandler from "../middleware/asyncHandler.js"

const router = express.Router();

router.post("/login", asyncHandler(login));
router.post("/verify", asyncHandler(verify));
router.get("/me", loginRequired, asyncHandler(me));

export default router
