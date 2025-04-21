import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/widgets/refill_tandon_widget/refill_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';
// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initRefillService() async {
  final service = FlutterBackgroundService();
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  // Konfigurasi inisialisasi notifikasi
  const AndroidInitializationSettings initAndroid =
      AndroidInitializationSettings('@mipmap/sihalal_icon');
  const InitializationSettings initSettings = InitializationSettings(
    android: initAndroid,
  );
  await notificationPlugin.initialize(initSettings);

  // Setup channel notifikasi dengan desain yang lebih kaya
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'Background Service',
    description: 'Channel untuk service background',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableLights: true,
    ledColor: Color.fromARGB(255, 255, 0, 0),
    // enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    showBadge: true,
  );

  // Buat channel notifikasi
  await notificationPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Konfigurasi service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Pengisian Tandon Air',
      initialNotificationContent: 'Pengisian tandon air sedang berlangsung',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: (_) => true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  final MqttController mqttController = Get.put(MqttController());
  if (service is AndroidServiceInstance) {
    showPengisianTandonNotification();
    mqttController.connectToBroker();
  }

  // Berfungsi saat APK dihapus dari recent apps.
  Timer.periodic(const Duration(milliseconds: 500), (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final isFull = prefs.getBool('isFull');
    if (isFull == true) {
      service.stopSelf();
      showTandonPenuhNotification();
      timer.cancel();
    }
  });

  // Handler untuk stop service
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}


