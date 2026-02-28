import mongoose from "mongoose";

const userTrackerLogSchema = new mongoose.Schema({
  tracker: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Tracker",
    required: true,
    index: true
  },

  location: {
    type: {
      type: String,
      enum: ["Point"],
      required: true,
      default: "Point"
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true
    }
  },

  speed: { type: Number, default: 0 },
  received_date: { type: Date, default: Date.now, index: true },
  battery: { type: Number, default: 0 },
  raw_data: String
}, {
  timestamps: true
});

// 🔥 GIS index
userTrackerLogSchema.index({ location: "2dsphere" });

// 🔥 tracker + date compound index (history query хурдан болгоно)
userTrackerLogSchema.index({ tracker: 1, received_date: -1 });

export default mongoose.model("UserTrackerLog", userTrackerLogSchema);
