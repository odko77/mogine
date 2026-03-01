// redisClient.js
import IORedis from "ioredis";
import colors from 'cli-color';

export const connection = new IORedis({
  host: "127.0.0.1",
  port: 6379,
  db: 3,                   // өөр DB ашиглаж болно
  maxRetriesPerRequest: null, // BullMQ & general best practice
});

connection.on("connect", () => console.log(colors.bgGreen.white("Redis connected!")));
connection.on("error", (err) => console.error(colors.bgGreen.red("Redis error"), err));

// Simple wrapper
const RedisClient = {
  /**
   * Set value
   * @param {string} key
   * @param {any} value - object, string, number
   * @param {number} [ttl] - seconds
   */
  async set(key, value, ttl = null) {
    const val = typeof value === "string" ? value : JSON.stringify(value);
    if (ttl) {
      await connection.set(key, val, "EX", ttl);
    } else {
      await connection.set(key, val);
    }
  },

  /**
   * Get value
   * @param {string} key
   * @returns {any} parsed JSON or string
   */
  async get(key) {
    const val = await connection.get(key);
    if (!val) return null;

    try {
      return JSON.parse(val);
    } catch {
      return val; // string
    }
  },

  /**
   * Delete key
   */
  async del(key) {
    await connection.del(key);
  },

  /**
   * Check if key exists
   * @returns {boolean}
   */
  async exists(key) {
    const res = await connection.exists(key);
    return res === 1;
  },

  // Бусад Redis commands хэрэгтэй бол нэмж болно
};

export default RedisClient;
