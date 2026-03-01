import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import morgan from "morgan";
import colors from 'cli-color'
import { initMqtt } from './mqtt/index.js'

import authRoutes from "./routes/auth.js";
import mapRoutes from './routes/map/index.js'
// import admin, { adminRouter } from "./admin.js";

import errorHandler from "./middleware/errorHandler.js";
import successFn from "./middleware/successFn.js";

dotenv.config();

const app = express();
app.use(express.json());
app.use(successFn)
app.use(morgan("dev"));

app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/map", mapRoutes);
// app.use(admin.options.rootPath, adminRouter);

app.use(errorHandler)

const mongoUri = process.env.MONGO_URI ?? process.env.MONGODB_URI;
if (!mongoUri) {
  console.error("Missing Mongo connection string. Set MONGO_URI (or MONGODB_URI) in backend/.env");
  process.exit(1);
}

mongoose
  .connect(mongoUri)
  .then(() => {
    console.log(colors.bgCyan.white("MongoDB connected"));

    initMqtt()

    const PORT = process.env.PORT || 5000;
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`)
      // console.log(`AdminJS started on http://localhost:${PORT}${admin.options.rootPath}`)
    });

  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
    process.exit(1);
  });
