import mongoose from "mongoose";

const trackerBorderSchema = new mongoose.Schema({
  userTrackers: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "UserTracker",
    },
  ],

  polygon: {
    type: {
      type: String,
      enum: ["Polygon"],
      required: true,
    },
    coordinates: {
      type: [[[Number]]], // [[[lng, lat]]]
      required: true,
    },
  },

  name: String,
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
});

trackerBorderSchema.index({ polygon: "2dsphere" });
export default mongoose.model("TrackerBorder", trackerBorderSchema);
