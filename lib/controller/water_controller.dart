import 'package:get/get.dart';
import 'package:iot_plant_control/models/water_time.dart';

class WaterController extends GetxController {
  var waterTime = RxList<WaterTime>([]);

  @override
  void onInit() {
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    waterTime.add(WaterTime(time: '08:00'));
    super.onInit();
  }

  void addWatering(String time) {
    waterTime.add(WaterTime(time: time));
  }

  void removeWatering(String id) {
    int index = waterTime.indexWhere((element) => element.id == id);
    waterTime.removeAt(index);
  }

  void toggleWatering(String id, bool value) {
    int index = waterTime.indexWhere((element) => element.id == id);
    if (index != -1) {
      waterTime[index].isActive.value = value;
    }
  }
}
