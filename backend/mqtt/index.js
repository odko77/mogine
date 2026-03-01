import mqtt from 'mqtt';
import colors from 'cli-color';
import TrackerService from '../services/tracker.js';

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
    console.log(colors.cyan.bold("Connected to the MQTT"));

    // Connect хийсний дараагаар tracker уудыг subscribe хийнэ
    mqttClient.subscribe(tracker4GTopic, function (err) {
      if (!err) {
        console.log(colors.blueBright(`${tracker4GTopic} subscribed successfully`));
      } else {
        console.log(colors.redBright(`${tracker4GTopic} subscription failed`));
      }
    });
  });

  mqttClient.on('error', function (err) {
    console.log(colors.bgRed.white(`MQTT connecting error :>> ${err}`));
  });

  mqttClient.on('message', async function (topic, message) {
    if (topic === tracker4GTopic) {
      const jsonMessage = JSON.parse(message.toString());
      TrackerService.processPayload(jsonMessage);
    }
  });

  return mqttClient;
};
