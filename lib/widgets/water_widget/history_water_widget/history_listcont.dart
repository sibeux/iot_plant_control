import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:iot_plant_control/controller/watering_controller/water_history_controller.dart';

class HistoryListcont extends StatelessWidget {
  const HistoryListcont({super.key});

  @override
  Widget build(BuildContext context) {
    final waterHistoryController = Get.find<WaterHistoryController>();
    return Obx(
      () =>
          waterHistoryController.isLoadingFetchData.value
              ? Center(
                child: CircularProgressIndicator(color: HexColor('#45D695')),
              )
              : waterHistoryController.waterHistoryList.isEmpty
              ? Center(
                child: Text(
                  'No history available',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: HexColor('#545454').withValues(alpha: 0.93),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Ambil data dari belakang.
                  final reversedIndex =
                      waterHistoryController.waterHistoryList.length -
                      1 -
                      index;
                  final DateTime date =
                      waterHistoryController
                          .waterHistoryList[reversedIndex]
                          .time;
                  final String formattedDate = DateFormat(
                    'd MMMM yyyy',
                    'id_ID',
                  ).format(date);
                  final String formattedTime = DateFormat('HH:mm').format(date);
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: (waterHistoryController
                                      .waterHistoryList[reversedIndex]
                                      .type ==
                                  'otomatis'
                              ? HexColor('#45D695')
                              : const Color.fromARGB(255, 164, 214, 255))
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$formattedDate, $formattedTime WIB',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${waterHistoryController.waterHistoryList[reversedIndex].duration} detik',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${waterHistoryController.waterHistoryList[reversedIndex].type.capitalize}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: waterHistoryController.waterHistoryList.length,
              ),
    );
  }
}
