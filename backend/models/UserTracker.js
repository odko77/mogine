import mongoose from "mongoose";

const userTrackerSchema = new mongoose.Schema({
  tracker: { type: mongoose.Schema.Types.ObjectId, ref: "Tracker" },
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  state: { type: String, enum: ["ACTIVE","DEACTIVE"], default: "ACTIVE" },
  created_date: { type: Date, default: Date.now },
  last_location: String,
  last_battery: Number,
  freq: Number,
  sim_number: String,
  sub_end_date: Date
});

export default mongoose.model("UserTracker", userTrackerSchema);
