import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot_plant_control/controller/clock_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final clockController = Get.find<ClockController>();
    return Container(
      padding: EdgeInsets.all(10.w),
      width: screenSize.width * 0.9, // 90% dari lebar layar
      height: screenSize.height * 0.5, // 50% dari tinggi layar
      child: SfDateRangePicker(
        backgroundColor: Colors.white,
        headerHeight: 50.h,
        selectionColor: Color.fromARGB(255, 69, 214, 149),
        todayHighlightColor: Color.fromARGB(255, 69, 214, 149),
        showActionButtons: true,
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: Colors.white,
          textAlign: TextAlign.center,
          textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        ),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          // Handle selection changes if needed.
          // print('Selected range: ${args.value}');
        },
        onSubmit: (p0) {
          clockController.tanggalTanam.value = p0.toString();
          Navigator.of(context).pop(true);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
        selectionMode: DateRangePickerSelectionMode.single,
        maxDate: DateTime.now(),
        showTodayButton: true,
        showNavigationArrow: true,
        initialDisplayDate:
            clockController.tanggalTanam.value.isNotEmpty
                ? DateTime.parse(clockController.tanggalTanam.value)
                : DateTime.now(),
        initialSelectedDate:
            clockController.tanggalTanam.value.isNotEmpty
                ? DateTime.parse(clockController.tanggalTanam.value)
                : DateTime.now(),
      ),
    );
  }
}
