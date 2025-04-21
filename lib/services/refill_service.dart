import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
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

  Timer.periodic(const Duration(milliseconds: 500), (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final isFull = prefs.getBool('isFull');
    if (isFull == true) {
      service.stopSelf();
      showTandonPenuhNotification();
      timer.cancel();
      if (kDebugMode) {
        print('Stopping service by timer...');
      }
    }
    if (kDebugMode) {
      print('Service is running...: ${DateTime.now()}');
    }
  });

  // Handler untuk stop service
  service.on('stopService').listen((event) {
    if (kDebugMode) {
      print('Stopping service...');
    }
    showTandonPenuhNotification();
    service.stopSelf();
  });
}

// Membuat notifikasi manual (opsional, jika ingin menampilkan notifikasi tambahan)
Future<void> showPengisianTandonNotification() async {
  AndroidNotificationDetails
  refillProgressNotification = AndroidNotificationDetails(
    'pengisian_tandon_air',
    'Notifikasi Tandon Air',
    channelDescription: 'Channel untuk notifikasi pengisian tandon air',
    importance: Importance.max,
    priority: Priority.high,
    // ongoing: true, // Notifikasi tidak bisa dihapus.
    // autoCancel: false, // Mencegah notifikasi dihapus dengan tap
    ticker: 'Pengisian tandon air',
    color: Color.fromARGB(255, 69, 214, 149),
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
    styleInformation: BigTextStyleInformation(
      'Tandon air Anda sedang dalam proses pengisian. Proses telah dimulai dan akan '
      'berlanjut hingga tandon terisi penuh. Anda akan diberi tahu ketika pengisian selesai.',
      htmlFormatBigText: true,
      contentTitle: 'Pengisian Tandon Air',
      htmlFormatContentTitle: true,
      summaryText: 'Pengisian sedang berlangsung',
      htmlFormatSummaryText: true,
    ),
    actions: <AndroidNotificationAction>[
      // AndroidNotificationAction(
      //   'lihat_action',
      //   'OK',
      //   icon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
      //   showsUserInterface: false,
      //   cancelNotification: true,
      // ),
    ],
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: refillProgressNotification,
  );

  await FlutterLocalNotificationsPlugin().show(
    0,
    'Pengisian Tandon Air',
    'Pengisian tandon air sedang berlangsung',
    notificationDetails,
  );
}

Future<void> showTandonPenuhNotification() async {
  AndroidNotificationDetails refillProgressNotification =
      AndroidNotificationDetails(
        'tandon_penuh',
        'Notifikasi Tandon Penuh',
        channelDescription: 'Channel untuk notifikasi tandon penuh',
        importance: Importance.max,
        priority: Priority.high,
        // ongoing: true, // Notifikasi tidak bisa dihapus.
        // autoCancel: false, // Mencegah notifikasi dihapus dengan tap
        ticker: 'Pengisian tandon air',
        color: Color.fromARGB(255, 69, 214, 149),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
        styleInformation: BigTextStyleInformation(
          'Tandon air Anda telah terisi penuh. Proses pengisian telah selesai.',
          htmlFormatBigText: true,
          contentTitle: 'Tandon Air Penuh',
          htmlFormatContentTitle: true,
          summaryText: 'Pengisian Selesai',
          htmlFormatSummaryText: true,
        ),
        actions: <AndroidNotificationAction>[
          // AndroidNotificationAction(
          //   'lihat_action',
          //   'OK',
          //   icon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
          //   showsUserInterface: false,
          //   cancelNotification: true,
          // ),
        ],
      );

  NotificationDetails notificationDetails = NotificationDetails(
    android: refillProgressNotification,
  );

  await FlutterLocalNotificationsPlugin().show(
    0,
    'Pengisian Selesai',
    'Tandon air Anda telah terisi penuh',
    notificationDetails,
  );
}
