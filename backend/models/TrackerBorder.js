import mongoose from "mongoose";

const trackerBorderSchema = new mongoose.Schema({
  user_tracker: { type: mongoose.Schema.Types.ObjectId, ref: "UserTracker" },
  polygon: String,
  name: String,
  created_at: { type: Date, default: Date.now },
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" }
});

export default mongoose.model("TrackerBorder", trackerBorderSchema);
