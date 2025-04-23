import 'package:get/get.dart';
import 'package:iot_plant_control/controller/watering_controller/check_overlapping.dart';
import 'package:iot_plant_control/controller/watering_controller/water_controller.dart';
import 'package:iot_plant_control/models/water_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWaterController extends GetxController {
  final WaterController waterController = Get.find<WaterController>();

  Future<void> addWatering() async {
    final prefs = await SharedPreferences.getInstance();
    bool isConflict = false;
    final String id =
        waterController.waterTime.isEmpty
            ? '1'
            : (int.parse(prefs.getString('water_id') ?? '0') + 1).toString();
    String time =
        '${waterController.selectedHour.value.toString().padLeft(2, '0')}:${waterController.selectedMinute.value.toString().padLeft(2, '0')}';
    if (waterController.waterTime.isEmpty) {
      isConflict = false;
    } else {
      // Cek apakah alarm baru memiliki waktu mulai yang sama dengan alarm yang ada / tumpang tindih.
      isConflict = checkOverlapping(
        id: id,
        newStart: DateTime.parse(
          '2023-01-01 $time:00',
        ), // Gunakan tanggal acak untuk waktu mulai
        newDuration: Duration(
          minutes: int.parse(waterController.selectedDuration.value),
        ),
        listAlarm: waterController.waterTime,
      );
    }
    waterController.waterTime.add(
      WaterTime(
        id: id,
        time: time,
        duration: waterController.selectedDuration.value,
        isActive: !isConflict,
        isConflict: isConflict,
      ),
    );
    waterController.sortWaterTime();
    await prefs.setString('water_id', id);
    waterController.toggleWatering(id, !isConflict);
  }
}
