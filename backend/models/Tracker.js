import mongoose from "mongoose";

const trackerSchema = new mongoose.Schema({
  name: String,
  imei: String,
  version: String,
  created_date: { type: Date, default: Date.now }
});

export default mongoose.model("Tracker", trackerSchema);
