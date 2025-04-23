import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

Future<void> showWateringNotification(bool isStart) async {
  String time = DateFormat('HH:mm').format(DateTime.now());
  AndroidNotificationDetails
  refillProgressNotification = AndroidNotificationDetails(
    'watering_notification',
    'Notifikasi Watering',
    channelDescription: 'Channel untuk notifikasi watering',
    importance: Importance.max,
    priority: Priority.high,
    ticker: isStart ? 'Penyiraman dimulai' : 'Penyiraman selesai',
    color: Color.fromARGB(255, 69, 214, 149),
    icon: '@mipmap/sihalal_icon',
    largeIcon: DrawableResourceAndroidBitmap('@mipmap/sihalal_icon'),
    styleInformation: BigTextStyleInformation(
      isStart
          ? 'Tanaman Anda sedang disiram pada $time WIB. Kami akan memberi tahu Anda ketika penyiraman selesai.'
          : 'Penyiraman telah selesai. Tanaman Anda sudah mendapatkan air yang cukup.',
      htmlFormatBigText: true,
      contentTitle: isStart ? 'Penyiraman Dimulai' : 'Penyiraman Selesai',
      htmlFormatContentTitle: true,
      summaryText: isStart ? 'Penyiraman Dimulai' : 'Penyiraman Selesai',
      htmlFormatSummaryText: true,
    ),
  );

  NotificationDetails notificationDetails = NotificationDetails(
    android: refillProgressNotification,
  );

  await FlutterLocalNotificationsPlugin().show(
    0,
    isStart ? 'Penyiraman Dimulai' : 'Penyiraman Selesai',
    isStart ? 'Tanaman Anda sedang disiram.' : 'Penyiraman telah selesai.',
    notificationDetails,
  );
}
