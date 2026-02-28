import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  first_name: String,
  last_name: String,
  phone_number: { type: String, unique: true },
  otp_code: String,
  last_joined_date: Date
});

export default mongoose.model("User", userSchema);
