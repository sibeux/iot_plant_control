import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/components/toast.dart';
import 'package:iot_plant_control/controller/refill_tandon_controller.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  late MqttServerClient client;
  final topic = 'sensor/data';
  var phValue = 0.0.obs;
  var temperatureValue = 0.0.obs;
  var tdsValue = 0.obs;
  var mqttIsConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    connectToBroker();
  }

  Future<void> connectToBroker() async {
    client = MqttServerClient(
      '0ec5706baec94b42b8a69d4a86aaa482.s1.eu.hivemq.cloud',
      // 'broker.emqx.io',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    );
    client.port = 8883;
    // client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // Untuk hivemq.cloud.
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    // client.setProtocolV311();
    // client.clientIdentifier;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
        )
        // ⬇️ khusus untuk eu.hivemq.cloud
        .authenticateAs(
          'hivemq.webclient.1745338710891',
          '9@2;P?0*w3jqNXCTIeaf',
        )
        // ⬆️ khusus untuk eu.hivemq.cloud
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
      mqttIsConnected.value = false;
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      if (payload.contains('suhu') &&
          payload.contains('tds') &&
          payload.contains('ph')) {
        if (kDebugMode) {
          print('📥 Received on $topic: $payload From Sensor!');
        }
        // {"suhu":27.00,"tds":0.00,"ph":11.55}
        try {
          final jsonData = jsonDecode(payload);

          // Pastikan value defaultnya tetap aman jika null atau error
          phValue.value = double.parse(
            (jsonData['ph'] ?? 0).toDouble().toStringAsFixed(1),
          );
          temperatureValue.value = double.parse(
            (jsonData['suhu'] ?? 0).toDouble().toStringAsFixed(1),
          );
          tdsValue.value = (jsonData['tds'] ?? 0).toDouble().round();
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ Error parsing payload: $e');
          }
        }
      } else if (payload.contains('tandonairsudahpenuh')) {
        if (kDebugMode) {
          print('📥 Received on $topic: $payload at ${DateTime.now()}');
        }
        Get.put(RefillTandonController()).toggleService(false);
      } else {
        if (kDebugMode) {
          print('📥 Received on $topic: $payload From Flutter!');
        }
      }
    });
  }

  void onConnected() {
    mqttIsConnected.value = true;
    if (kDebugMode) {
      print('✅ MQTT Connected');
    }
    client.subscribe(topic, MqttQos.atMostOnce);
    showToast('✅ MQTT Connected');
  }

  void onDisconnected() {
    mqttIsConnected.value = false;
    if (kDebugMode) {
      print('⚠️ MQTT Disconnected');
    }
    showToast('⚠️ MQTT Disconnected');
  }

  void publishToBroker(String value) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(value);

      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      if (kDebugMode) {
        print('📤 Published $value to $topic');
      }
      showToast('Published $value to $topic');
      mqttIsConnected.value = true;
    } else {
      mqttIsConnected.value = false;
      if (kDebugMode) {
        print('❗ MQTT not connected');
      }
      showToast('❗MQTT not connected');
    }
  }

  @override
  void onClose() {
    client.disconnect();
    super.onClose();
  }
}
