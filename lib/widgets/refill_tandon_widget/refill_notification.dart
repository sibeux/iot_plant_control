// Membuat notifikasi manual (opsional, jika ingin menampilkan notifikasi tambahan)
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showPengisianTandonNotification() async {
  AndroidNotificationDetails
  refillProgressNotification = AndroidNotificationDetails(
    'penyiraman_manual_channel',
    'Notifikasi Siram Manual',
    channelDescription: 'Channel untuk notifikasi penyiraman manual',
    importance: Importance.max,
    priority: Priority.high,
    // ongoing: true, // Notifikasi tidak bisa dihapus.
    // autoCancel: false, // Mencegah notifikasi dihapus dengan tap
    ticker: 'Pengisian tandon air',
    color: Color.fromARGB(255, 69, 214, 149),
    icon: '@mipmap/sihalal_icon',
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
    styleInformation: BigTextStyleInformation(
      'Tanaman Anda sedang dalam proses penyiraman. Proses telah dimulai dan akan '
      'berlanjut hingga penyiraman dihentikan.',
      htmlFormatBigText: true,
      contentTitle: 'Penyiraman Manual',
      htmlFormatContentTitle: true,
      summaryText: 'Penyiraman manual sedang berlangsung',
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
    169,
    'Penyiraman Manual',
    'Penyiraman manual sedang berlangsung',
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
        icon: '@mipmap/sihalal_icon',
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
    // Harusnya ID itu berbeda-beda.
    // Ini khusus agar dia me-replace notifikasi pengisian tandon di atas.
    169,
    'Pengisian Selesai',
    'Tandon air Anda telah terisi penuh',
    notificationDetails,
  );
}
