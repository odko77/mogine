import mqtt from 'mqtt';
import colors from 'cli-color';
import TrackerService from '../services/tracker.js';
import { mqttQueue } from '../queue.js';
import Tracker from "../models/Tracker.js"

const mqttPath = '/mqtt';
const tracker4GTopic = "ondotracks/mqtt";

/**
 * Initialize MQTT client
 */
export const initMqtt = () => {
  const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;
  const connectUrl = `${process.env.MQTT_PROTOCOL}://${process.env.MQTT_HOST}:${process.env.MQTT_PORT}${mqttPath}`;

  const mqttClient = mqtt.connect(connectUrl, {
    clientId,
    clean: true,
    connectTimeout: 4000,
    username: process.env.MQTT_USER,
    password: process.env.MQTT_PASSWORD,
    reconnectPeriod: 1000,
    rejectUnauthorized: false,
  });

  /** Subscribing to topic on connection */
  mqttClient.on('connect', function () {
    console.log(colors.bgMagenta.white("MQQT connected"));

    Tracker.find({}).then(
      (trackers) => {
        trackers.map(
          (tr) => {
            console.log("imei", tr.imei);
          }
        )
        // Connect хийсний дараагаар tracker уудыг subscribe хийнэ
        mqttClient.subscribe(tracker4GTopic, function (err) {
          if (!err) {
            console.log(colors.blueBright(`${tracker4GTopic} subscribed successfully`));
          } else {
            console.log(colors.redBright(`${tracker4GTopic} subscription failed`));
          }
        });
      }
    )
  });

  mqttClient.on('error', function (err) {
    console.log(colors.bgRed.white(`MQTT connecting error :>> ${err}`));
  });

  mqttClient.on('message', function (topic, message) {
    if (topic === tracker4GTopic) {
      let jsonMessage;

      try {
        jsonMessage = JSON.parse(message.toString());
      } catch (err) {
        console.error("Invalid JSON FROM MQTT:", err);
        return;
      }

      // ✅ Message-ийг queue руу хийж өгнө
      mqttQueue.add("mqttMessage", jsonMessage, {
        attempts: 3,
        backoff: {
          type: "exponential",
          delay: 1000,
        },
      }).catch(err => {
        console.error("Queue add error", err);
      });


      // TrackerService.processPayload(jsonMessage).then(result => {
      //   console.log("processPayload result", result);
      // }).catch(err => {
      //   console.log("processPayload error", err);
      // });
    }
  });

  return mqttClient;
};
