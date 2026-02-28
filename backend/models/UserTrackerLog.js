import mongoose from "mongoose";

const userTrackerLogSchema = new mongoose.Schema({
  tracker: { type: mongoose.Schema.Types.ObjectId, ref: "Tracker" },
  location: String,
  speed: Number,
  received_date: Date,
  battery: Number,
  raw_data: String
});

export default mongoose.model("UserTrackerLog", userTrackerLogSchema);
