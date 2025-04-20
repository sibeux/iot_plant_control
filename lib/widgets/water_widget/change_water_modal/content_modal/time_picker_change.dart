import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

class TimePickerChange extends StatelessWidget {
  const TimePickerChange({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Jam
          SizedBox(
            width: 100.w,
            height: 180.h,
            child: CupertinoPicker(
              looping: true,
              itemExtent: 60,
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              scrollController: waterController.hourController,
              onSelectedItemChanged: (index) {
                waterController.selectedHour.value = index;
                waterController.setWaterTimeDifference(
                  waterController.selectedHour.value,
                  waterController.selectedMinute.value,
                );
              },
              children: List<Widget>.generate(24, (index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 28.sp),
                  ),
                );
              }),
            ),
          ),
          Text(":", style: TextStyle(fontSize: 24.sp)),
          // Menit
          SizedBox(
            width: 100.w,
            height: 150.h,
            child: CupertinoPicker(
              looping: true,
              itemExtent: 60,
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              scrollController: waterController.minuteController,
              onSelectedItemChanged: (index) {
                waterController.selectedMinute.value = index;
                waterController.setWaterTimeDifference(
                  waterController.selectedHour.value,
                  waterController.selectedMinute.value,
                );
              },
              children: List<Widget>.generate(60, (index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 28.sp),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
