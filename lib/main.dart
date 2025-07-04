import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iot_plant_control/controller/mqtt/mqtt_controller.dart';
import 'package:iot_plant_control/controller/refill_tandon_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/permission_controller.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/screen/splash_screen.dart';
// import 'package:iot_plant_control/services/example_background_service.dart';
import 'package:iot_plant_control/services/refill_service.dart';
import 'package:get_storage/get_storage.dart';

final ReceivePort port = ReceivePort();
const String isolateName = 'water_alarm_port';

void main() async {
  // Dibutuhkan setpreferredOrientations.
  WidgetsFlutterBinding.ensureInitialized();
  
  await AndroidAlarmManager.initialize();

  final permissionController = Get.put(PermissionController());
  await permissionController.requestExactAlarmPermission();
  // Khusus di Android 13+.
  await permissionController.requestNotificationPermissionIfNeeded();
  // RefillTandonCotroller & WaterController dipanggil di sini,
  // karena di persistentbar harus dipanggil saat buka screen masing-masing.
  Get.put(MqttController());
  Get.put(RefillTandonController());
  Get.put(WaterController());

  // await initServiceExample();
  await initRefillService();
  await GetStorage.init();

  // For alarm manager.
  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(port.sendPort, isolateName);

  port.listen((message) {
    if (message is String) {
      Get.find<WaterController>().isWaterOn.value = true;
      Get.find<WaterController>().timeNotifier.value = message.toString();
      if (message == 'done'){
        Get.find<WaterController>().isWaterOn.value = false;
      }
    } 
  });
  // Sampai Sini.

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Biar transparan atau bisa diganti warna lain
      statusBarIconBrightness:
          Brightness.dark, // <- ini yang bikin ikon jadi hitam
      statusBarBrightness:
          Brightness.light, // iOS only, tetap disarankan ditambahkan
    ),
  );

  // Mengunci orientasi ke portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 804), // ukuran HP kamu
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyPlant',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            fontFamily: 'DmSans',
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
