// queue.js
import { Queue, Worker } from "bullmq";
import MqttService from "./services/tracker.js";

import { connection } from "./redisClient.js";

// Queue үүсгэх
export const mqttQueue = new Queue("mqttQueue", { connection });

// Worker үүсгэх
export const mqttWorker = new Worker(
  "mqttQueue",
  async job => {
    // job.data дотор message байна
    const payload = job.data;

    console.log("Worker received message", payload);

    try {
      const result = await MqttService.processPayload(payload);
      return result;
    } catch (err) {
      console.error("Worker processPayload error", err);
      throw err;
    }
  },
  { connection, concurrency: 10 } // concurrent 10 job зэрэг process хийнэ
);

mqttWorker.on("completed", (job, result) => {
  console.log(`Job completed: ${job.id}`, result.event);
});

mqttWorker.on("failed", (job, err) => {
  console.error(`Job failed: ${job.id}`, err);
});
