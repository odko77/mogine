import mongoose from "mongoose";

const paymentSchema = new mongoose.Schema({
  name: String,
  price: Number,
  final_price: Number,
  description: String
});

export default mongoose.model("Payment", paymentSchema);
