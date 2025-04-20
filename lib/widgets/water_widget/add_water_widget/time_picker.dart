import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot_plant_control/controller/water_controller.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({
    super.key,
    required this.waterController,
  });

  final WaterController waterController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Jam
          SizedBox(
            width: 100.w,
            height: 300.h,
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
            height: 300.h,
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
