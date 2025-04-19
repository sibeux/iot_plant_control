import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  late MqttServerClient client;
  final topic = 'greenhouse/ph';
  var phValue = 0.obs;
  var temperatureValue = 0.obs;

  @override
  void onInit() {
    super.onInit();
    connectToBroker();
  }

  Future<void> connectToBroker() async {
    client = MqttServerClient(
      'broker.emqx.io',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    );
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
        )
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      if (kDebugMode) {
        print('❌ MQTT connection failed: $e');
      }
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      if (!payload.contains('TDS:')) {
        if (kDebugMode) {
          print('📥 Received on $topic: $payload. From Sensor!');
        }
        // contoh payload: ph:12,temp:32
        final parts = payload.split(',');
        Map<String, String> data = {};

        for (var part in parts) {
          var kv = part.split(':');
          if (kv.length == 2) {
            data[kv[0].trim()] = kv[1].trim();
          }
        }
        phValue.value = int.parse(data['ph'] ?? '0');
        temperatureValue.value = int.parse(data['temp'] ?? '0');
      } else {
        if (kDebugMode) {
          print('📥 Received on $topic: $payload. From Flutter!');
        }
      }
    });
  }

  void onConnected() {
    if (kDebugMode) {
      print('✅ MQTT Connected');
    }
    client.subscribe(topic, MqttQos.atMostOnce);
  }

  void onDisconnected() {
    if (kDebugMode) {
      print('⚠️ MQTT Disconnected');
    }
  }

  void publishTDS(String value) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(value);

      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      if (kDebugMode) {
        print('📤 Published $value to $topic');
      }
    } else {
      if (kDebugMode) {
        print('❗ MQTT not connected');
      }
    }
  }

  @override
  void onClose() {
    client.disconnect();
    super.onClose();
  }
}
