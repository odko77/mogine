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

  // Сүүлийн MQTT дата бүгд нэг object дотор (GIS index: last_data.location)
  last_data: {
    location: {
      type: {
        type: String,
        enum: ["Point"],
        default: "Point"
      },
      coordinates: { type: [Number] } // [lng, lat]
    },
    imei: String,
    lat: Number,
    lon: Number,
    tst: Number,
    alt: Number,
    vel: Number,
    vbat: Number,
    vbat_v: Number,
    temp: Number,
    batt: Number
  },

  freq: {
    type: Number,
    default: 15 // минутын давтамж гэж үзэв
  },

  sub_end_date: {
    type: Date,
    index: true
  },

  currentBorder: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "TrackerBorder",
  },
  isInsideBorder: {
    type: Boolean,
    default: false,
  },
}, {
  timestamps: true
});

// 🔥 GIS index
userTrackerSchema.index({ "last_data.location": "2dsphere" });

// 🔥 Нэг user-д нэг tracker 1 л байх бол
userTrackerSchema.index({ tracker: 1, user: 1 }, { unique: true });

export default mongoose.model("UserTracker", userTrackerSchema);
