import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleDate extends StatelessWidget {
  const TitleDate({super.key, required this.formattedDate});

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'MyPlant',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black.withAlpha(180),
            ),
          ),
          SizedBox(width: 20.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color(0xffd5feec),
            ),
            child: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 69, 214, 149),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
