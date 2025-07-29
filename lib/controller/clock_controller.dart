import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iot_plant_control/components/colorize_terminal.dart';

class ClockController extends GetxController {
  var timeNotifier = ''.obs; // Observable variable to hold the time
  var refreshTime =
      false.obs; // Observable variable to hold the time for refresh
  var jumlahHari = '?'.obs;
  var tanggalTanam = ''.obs;
  late Timer _timer;

  // Update the time every second
  void _updateTime() {
    final now = DateTime.now();
    final locale = 'id_ID'; // Can dynamically fetch this if needed
    final formatter = DateFormat.Hm(locale); // 24-hour format: HH:mm
    timeNotifier.value = formatter.format(now);
    refreshTime.value = !refreshTime.value; // Trigger a refresh
  }

  @override
  void onInit() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    super.onInit();
  } // Dispose of the timer when done

  @override
  void onClose() {
    _timer.cancel();
    timeNotifier.close();
    super.onClose();
  }

  Future<void> getDatePlanting() async {
    const String url =
        'https://sibeux.my.id/project/myplant-php-jwt/api/date_planting?method=get_planting_date';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200 || response.body.isEmpty) {
        logError('Failed to fetch planting date: HTTP ${response.statusCode}');
        return;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != 'success') {
        logError('API returned non-success status: ${data['status']}');
        return;
      }

      final dateString = data['data']?['date'];
      if (dateString == null || dateString.isEmpty) {
        logError('No planting date returned in data.');
        return;
      }

      final plantingDate = DateTime.tryParse(dateString);
      if (plantingDate == null) {
        logError('Invalid date format: $dateString');
        return;
      }

      tanggalTanam.value = plantingDate.toIso8601String();

      final now = DateTime.now();
      final daysSince = now.difference(plantingDate).inDays + 1;
      jumlahHari.value = daysSince.toString();
    } catch (e, stack) {
      logError('Exception during date fetch: $e\n$stack');
    }
  }

  Future<void> setDatePlanting(DateTime date) async {
    const String url =
        'https://sibeux.my.id/project/myplant-php-jwt/api/date_planting';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'method': 'set_planting_date', 'date': date.toIso8601String()},
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        logError('Failed to set planting date: HTTP ${response.statusCode}');
        return;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] != 'success') {
        logError('API returned error: ${data['message'] ?? 'Unknown error'}');
        return;
      }

      // Optional: logging success
      logSuccess('Planting date updated successfully');
    } catch (e, stack) {
      logError('Exception while setting planting date: $e\n$stack');
    }
  }

}
