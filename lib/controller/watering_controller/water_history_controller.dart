import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iot_plant_control/components/colorize_terminal.dart';
import 'package:iot_plant_control/models/water_history.dart';

class WaterHistoryController extends GetxController {
  var isLoadingFetchData = false.obs;

  RxList<WaterHistory> waterHistoryList = <WaterHistory>[].obs;

  Future<void> fetchWaterHistory() async {
    isLoadingFetchData.value = true;
    const String url =
        "https://sibeux.my.id/project/myplant-php-jwt/api/water_history?method=get_water_history";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200 || response.body.isEmpty) {
        logError('Failed to fetch water history: HTTP ${response.statusCode}');
        return;
      }

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['status'] != 'success') {
        logError('API returned non-success status: ${body['status']}');
        return;
      }

      final data = body['data'] ?? [];
      if (data.isEmpty) {
        logError('No water history data found');
        return;
      }

      // Start of kode gajah.
      waterHistoryList.value =
          data.map<WaterHistory>((item) {
            return WaterHistory.fromJson(item as Map<String, dynamic>);
          }).toList();
      // End of kode gajah.

      if (waterHistoryList.isEmpty) {
        logError('No valid water history entries found');
        return;
      }

      logSuccess(
        'Water history fetched successfully: ${waterHistoryList.length} entries',
      );
    } catch (e, stackTrace) {
      logError('Error fetching water history: $e: $stackTrace');
    } finally {
      isLoadingFetchData.value = false;
    }
  }
}
