// models/PointName.js
import mongoose from "mongoose";

const pointNameSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  name: { type: String, required: true },
  location: {
    type: { type: String, enum: ["Point"], required: true },
    coordinates: { type: [Number], required: true }, // [lon, lat]
  },
  icon_name: String,
  icon_color: String,
});

// 2dsphere index нь GeoJSON query-д хэрэгтэй
pointNameSchema.index({ location: "2dsphere" });

export default mongoose.model("PointName", pointNameSchema);
