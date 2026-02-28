import mqtt from 'mqtt';
import colors from 'cli-color';

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
    console.log("> topic", topic);
    console.log("> message", message.toString());

    if (topic === tracker4GTopic) {
      try {
        const jsonMessage = JSON.parse(message.toString());
        console.log("json message", jsonMessage);
      } catch (err) {
        console.log("mqtt parse error:", err);
      }
    }
  });

  return mqttClient;
};
