import paho.mqtt.client as mqtt
import time
import random
import ssl

# Konfigurasi broker MQTT
# BROKER = "broker.emqx.io"
# PORT = 1883
# TOPIC = "greenhouse/ph"

BROKER = "0ec5706baec94b42b8a69d4a86aaa482.s1.eu.hivemq.cloud"
PORT = 8883
# ganti dengan username HiveMQ kamu
TOPIC = "sensor/data"
USERNAME = "hivemq.webclient.1745338710891"
PASSWORD = "9@2;P?0*w3jqNXCTIeaf"  # ganti dengan password HiveMQ kamu

# Inisialisasi client MQTT
client = mqtt.Client()

# Set username dan password
client.username_pw_set(USERNAME, PASSWORD)

# Aktifkan TLS
client.tls_set(tls_version=ssl.PROTOCOL_TLS)

def connect():
    client.connect(BROKER, PORT)
    print("Connected to MQTT Broker")

def generate_sensor_data():
    # Simulasi nilai integer pH dan suhu
    ph = random.randint(0, 14)           # pH skala 0-14
    temp = random.randint(20, 40)        # Suhu 20-40 derajat Celsius
    tds = random.randint(500, 1500)        # TDS 0-1000 ppm
    # return f"ph:{ph},temp:{temp}" # "ph:5,temp:23"
    return f'{{"suhu": {temp}, "tds": {tds}, "ph": {ph}}}' 

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
