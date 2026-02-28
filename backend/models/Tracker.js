import mongoose from "mongoose";

const trackerSchema = new mongoose.Schema({
  name: String,
  imei: String,
  version: String,

  sim_number: {
    type: String,
  },
  sim_operator: {
    type: String,
  },
  sim_negj: {
    type: String,
  },

});

export default mongoose.model("Tracker", trackerSchema);
