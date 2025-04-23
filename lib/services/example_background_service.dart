import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initServiceExample() async {
  final service = FlutterBackgroundService();
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  // Konfigurasi inisialisasi notifikasi
  const AndroidInitializationSettings initAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: initAndroid,
  );
  await notificationPlugin.initialize(initSettings);

  // Setup channel notifikasi dengan desain yang lebih kaya
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_service_channel',
    'Background Service',
    description: 'Channel untuk service background',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableLights: true,
    ledColor: Color.fromARGB(255, 255, 0, 0),
    enableVibration: true,
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
      notificationChannelId: 'my_service_channel',
      initialNotificationTitle: 'Service Aktif',
      initialNotificationContent: 'Aplikasi berjalan di background',
      foregroundServiceNotificationId: 888,

      // Ikon notifikasi kustom
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
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();

    // Style notifikasi yang lebih kaya
    service.setForegroundNotificationInfo(
      title: "Layanan Berjalan",
      content: "Aplikasi sedang memproses data",
    );
  }

  int count = 0;

  // Timer untuk update notifikasi dengan informasi yang lebih dinamis
  Timer.periodic(const Duration(seconds: 5), (timer) {
    count++;
    if (service is AndroidServiceInstance) {
      // Memperbarui notifikasi dengan progress atau informasi
      if (count % 2 == 0) {
        service.setForegroundNotificationInfo(
          title: "Memproses Data",
          content: "Pemrosesan data sedang berjalan: ${count * 10}%",
        );
      } else {
        service.setForegroundNotificationInfo(
          title: "Layanan Aktif",
          content: "Waktu aktif: ${count * 5} detik",
        );
      }
    }
  });

  // Handler untuk stop service
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

// Membuat notifikasi manual (opsional, jika ingin menampilkan notifikasi tambahan)
Future<void> showCustomNotification() async {
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'my_custom_channel',
    'Custom Notifications',
    channelDescription: 'Channel untuk notifikasi kustom',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    color: Color(0xFF2196F3),
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    styleInformation: BigTextStyleInformation(
      'Ini adalah pesan panjang yang akan ditampilkan dengan gaya Big Text. '
      'Berguna untuk menampilkan pesan yang panjang dan detail.',
      htmlFormatBigText: true,
      contentTitle: 'Judul Besar',
      htmlFormatContentTitle: true,
      summaryText: 'Ringkasan Pesan',
      htmlFormatSummaryText: true,
    ),
    actions: <AndroidNotificationAction>[
      AndroidNotificationAction(
        'action_1',
        'Lihat',
        icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'action_2',
        'Tutup',
        icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        cancelNotification: true,
      ),
    ],
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  await FlutterLocalNotificationsPlugin().show(
    0,
    'Notifikasi Kustom',
    'Ini adalah pesan notifikasi kustom',
    notificationDetails,
  );
}
