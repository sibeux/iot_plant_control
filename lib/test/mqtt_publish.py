import paho.mqtt.client as mqtt
import time
import random

# Konfigurasi broker MQTT
BROKER = "broker.hivemq.com"
PORT = 1883
TOPIC = "greenhouse/ph"

# Inisialisasi client MQTT
client = mqtt.Client()

def connect():
    client.connect(BROKER, PORT)
    print("Connected to MQTT Broker")

def generate_sensor_data():
    # Simulasi nilai integer pH dan suhu
    ph = random.randint(0, 14)           # pH skala 0-14
    temp = random.randint(20, 40)        # Suhu 20-40 derajat Celsius
    return f"ph:{ph},temp:{temp}"

def publish_loop():
    while True:
        data = generate_sensor_data()
        client.publish(TOPIC, data)
        print(f"Published: {data}")
        time.sleep(1)

if __name__ == "__main__":
    try:
        connect()
        publish_loop()
    except KeyboardInterrupt:
        print("\nStopped by user")
        client.disconnect()
