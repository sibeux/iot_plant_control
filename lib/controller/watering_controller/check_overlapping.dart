import 'package:iot_plant_control/models/water_time.dart';

bool checkOverlapping({
  required String id,
  required DateTime newStart,
  required Duration newDuration,
  required List<WaterTime> listAlarm,
}) {
  final newEnd = newStart.add(newDuration); // Hitung waktu akhir alarm baru

  for (var alarm in listAlarm) {
    if (alarm.id == id) continue; // Lewati alarm yang sama

    final existingStart = DateTime.parse("2023-01-01 ${alarm.time}:00");
    final existingDuration = Duration(minutes: int.parse(alarm.duration));
    final existingEnd = existingStart.add(existingDuration);

    // Cek apakah alarm baru memiliki waktu mulai yang sama dengan alarm yang ada
    final isSameTime = existingStart.isAtSameMomentAs(newStart);

    // Cek apakah alarm baru menabrak waktu alarm yang ada
    final isOverlap =
        newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);

    // Jika ada alarm yang tumpang tindih atau memiliki waktu mulai yang sama
    if (isSameTime || isOverlap) {
      return true; // Ada konflik
    }
  }

  return false; // Tidak ada konflik
}

// Fungsi untuk validasi alarm yang tersisa
void validateSortedAlarms(List<WaterTime> alarms) {
  // Reset semua alarm terlebih dahulu
  for (final alarm in alarms) {
    alarm.isConflict.value = false;
  }

  for (int i = 0; i < alarms.length; i++) {
    final current = alarms[i];
    final currentStart = DateTime.parse("2023-01-01 ${current.time}:00");
    final currentDuration = Duration(minutes: int.parse(current.duration));
    final currentEnd = currentStart.add(currentDuration);

    for (int j = i + 1; j < alarms.length; j++) {
      final next = alarms[j];
      final nextStart = DateTime.parse("2023-01-01 ${next.time}:00");

      // Jika alarm selanjutnya dimulai setelah alarm sekarang selesai, tidak perlu lanjut
      if (nextStart.isAfter(currentEnd)) break;

      final isOverlap = nextStart.isBefore(currentEnd);
      final isSameTime = currentStart.isAtSameMomentAs(nextStart);

      if (isOverlap || isSameTime) {
        current.isConflict.value = true; // Tandai konflik
        next.isConflict.value = true; // Tandai konflik
      }
    }
  }

  // Setelah validasi, pastikan alarm yang tersisa tidak konflik
  if (alarms.length == 1) {
    alarms[0].isConflict.value =
        false; // Tidak ada konflik jika hanya 1 alarm tersisa
  }
}
