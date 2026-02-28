import mongoose from "mongoose";

const userPaymentSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  payment: { type: mongoose.Schema.Types.ObjectId, ref: "Payment" },
  created_date: { type: Date, default: Date.now }
});

export default mongoose.model("UserPayment", userPaymentSchema);
