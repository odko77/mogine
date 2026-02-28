import AdminJS from "adminjs";
import AdminJSExpress from "@adminjs/express";
import mongoose from "mongoose";
import * as AdminJSMongoose from "@adminjs/mongoose";

import User from "./models/User.js";
import Tracker from "./models/Tracker.js";
import UserTracker from "./models/UserTracker.js";
import UserTrackerLog from "./models/UserTrackerLog.js";
import UserPayment from "./models/UserPayment.js";
import Payment from "./models/Payment.js";
import PointName from "./models/PointName.js";
import TrackerBorder from "./models/TrackerBorder.js";

AdminJS.registerAdapter(AdminJSMongoose);

const admin = new AdminJS({
  rootPath: "/admin",
  branding: {
    companyName: "Mongine Admin",    // Top bar дээр гарчиг
    logo: "https://i.postimg.cc/9fHLDGtZ/mongine-logo.png",  // Top-left logo
    softwareBrothers: false,             // AdminJS logo-г хаах
    favicon: "https://i.postimg.cc/9fHLDGtZ/mongine-logo.png" // browser tab icon
  },
  resources: [

    User,
    Tracker,
    UserPayment,
    Payment,
    PointName,
    TrackerBorder,

    // {
    //   resource: UserTracker,
    //   options: {
    //     properties: {
    //       last_location: { isVisible: false },
    //       "last_location.type": { isVisible: false },
    //       "last_location.coordinates": { isVisible: false },
    //     },
    //   },
    // },
    // {
    //   resource: UserTrackerLog,
    //   options: {
    //     properties: {
    //       location: { isVisible: false },
    //       "location.type": { isVisible: false },
    //       "location.coordinates": { isVisible: false },
    //     },
    //     actions: {
    //       new: { isAccessible: false },
    //       edit: { isAccessible: false },
    //       delete: { isAccessible: false },
    //     },
    //   },
    // }

  ],
});

// 🔐 Authentication (заавал хийхийг зөвлөж байна)
export const adminRouter = AdminJSExpress.buildAuthenticatedRouter(
  admin,
  {
    authenticate: async (email, password) => {
      if (email === "admin@test.com" && password === "1234") {
        return { email };
      }
      return null;
    },
    cookiePassword: "supersecretpassword",
  },
  null,
  {
    resave: false,
    saveUninitialized: true,
  }
);

export default admin;
