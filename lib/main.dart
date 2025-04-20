import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iot_plant_control/screen/persistent_bar_screen.dart';
import 'package:iot_plant_control/services/example_background_service.dart';

void main() async {
  // Dibutuhkan setpreferredOrientations.
  WidgetsFlutterBinding.ensureInitialized();

  await initServiceExample();

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
          home: PersistentBarScreen(),
        );
      },
    );
  }
}
