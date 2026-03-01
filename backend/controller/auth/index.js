import User from "../../models/User.js";
import jwt from "jsonwebtoken";
import asyncHandler from '../../middleware/asyncHandler.js'

// Generate OTP and return it in response (test)
export async function login(req, res) {
  const { phone_number } = req.body;
  if (!phone_number) {
    throw req.sendError("ERR_005", "Утасны дугаараа")
  }

  let user = await User.findOne({ phone_number });
  if (!user) user = await User.create({ phone_number });

  const otp_code = Math.floor(100000 + Math.random() * 900000).toString();
  user.otp_code = otp_code;
  await user.save();

  res.json({ success: true, data: { otp_code }, error: null });
  return req.sendData({ otp_code })
}

// Verify OTP and return JWT
export async function verify(req, res) {
  const { phone_number, otp_code } = req.body;
  const user = await User.findOne({ phone_number });

  if (!user) {
    throw req.sendError("ERR_006")
  }

  if (user.otp_code !== otp_code) {
    throw req.sendError("ERR_006")
  }

  const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
  user.otp_code = null;
  await user.save();

  return req.sendData({ token })
}

// Нэвтэрсэн хэрэглэгчийн мэдээлэл
export async function me(req, res) {
  const user = await User.findById(req.userId).select("-otp_code");
  if (!user) throw req.sendError("ERR_007");
  return req.sendData(user);
}

export const updateMe = asyncHandler(async (req, res) => {
  const userId = req.userId; // req.userId ашиглана

  if (!req.body) {
    return res.status(400).json({ success: false, error: "Update data required" });
  }

  // User update
  const user = await User.findByIdAndUpdate(userId, req.body, { new: true });
  return req.sendData(user);
})
