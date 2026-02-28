import mongoose from "mongoose";

const userTrackerSchema = new mongoose.Schema({
  tracker: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Tracker",
    required: true,
    index: true
  },

  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    index: true
  },

  state: {
    type: String,
    enum: ["ACTIVE", "DEACTIVE"],
    default: "ACTIVE",
    index: true
  },

  created_date: {
    type: Date,
    default: Date.now
  },

  // 🔥 GIS болгосон
  last_location: {
    type: {
      type: String,
      enum: ["Point"],
      default: "Point"
    },
    coordinates: {
      type: [Number], // [lng, lat]
      default: undefined
    }
  },

  last_battery: {
    type: Number,
    default: 0
  },

  freq: {
    type: Number,
    default: 15 // минутын давтамж гэж үзэв
  },

  sim_number: {
    type: String,
    index: true
  },

  sub_end_date: {
    type: Date,
    index: true
  }

}, {
  timestamps: true
});

// 🔥 GIS index
userTrackerSchema.index({ last_location: "2dsphere" });

// 🔥 Нэг user-д нэг tracker 1 л байх бол
userTrackerSchema.index({ tracker: 1, user: 1 }, { unique: true });

export default mongoose.model("UserTracker", userTrackerSchema);
