import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenSizePage extends StatelessWidget {
  const ScreenSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (kDebugMode) {
      print('Lebar: ${size.width}, Tinggi: ${size.height}');
    }

    return Scaffold(
      appBar: AppBar(title: Text('Ukuran Layar')),
      body: Center(
        child: Text(
          'Lebar: ${size.width.toStringAsFixed(2)}\n'
          'Tinggi: ${size.height.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
