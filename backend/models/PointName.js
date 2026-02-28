import mongoose from "mongoose";

const pointNameSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  name: String,
  location: String,
  icon_name: String,
  icon_color: String
});

export default mongoose.model("PointName", pointNameSchema);
