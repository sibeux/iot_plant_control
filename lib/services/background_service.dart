// Inisialisasi service dan notifikasi
import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initService() async {
  final service = FlutterBackgroundService();
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  // Setup channel notifikasi
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_service_channel',
    'Background Service',
    description: 'Channel untuk service background',
    importance: Importance.high,
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
      notificationChannelId: 'my_service_channel',
      initialNotificationTitle: 'Service Aktif',
      initialNotificationContent: 'Sedang berjalan di background',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: (_) => true,
    ),
  );
}

// Fungsi yang dijalankan ketika service mulai
@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  // Jika service adalah instance Android
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  // Timer untuk update notifikasi
  Timer.periodic(const Duration(seconds: 5), (timer) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Background Service",
        content: "Berjalan selama: ${timer.tick * 5} detik",
      );
    }
  });

  // Handler untuk stop service
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}
