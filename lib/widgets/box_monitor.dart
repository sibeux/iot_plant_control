import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class BoxMonitor extends StatelessWidget {
  const BoxMonitor({
    super.key,
    required this.id,
    required this.title,
    required this.status,
    required this.value,
  });

  final int id;
  final String title, status, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              id == 1
                  ? [HexColor("#ebfae5"), HexColor("#e3f6f4")]
                  : id == 2
                  ? [HexColor("#e2fafd"), HexColor("#dfe6ff")]
                  : [HexColor("#fce0e3"), HexColor("#f8bbd0")],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 12.sp)),
                    SizedBox(height: 3.h),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
              ],
            ),
            SizedBox(height: 5.h),
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors:
                        id == 1
                            ? [HexColor('#80d756'), HexColor('#4fc09c')]
                            : id == 2
                            ? [HexColor('#2ad4f8'), HexColor('#37c1e7')]
                            : [HexColor('#f3516d'), HexColor('#f3516d')],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Harus white.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
