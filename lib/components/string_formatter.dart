import 'package:timeago/timeago.dart' as timeago;

String timeAgo(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    timeago.setLocaleMessages('id', timeago.IdMessages());
    return timeago.format(dateTime, locale: 'id');
  } catch (e) {
    return "Beberapa saat yang lalu";
  }
}

DateTime convertStringToDateTime(String time) {
  // Ambil tanggal hari ini
  DateTime now = DateTime.now();

  // Pisahkan waktu dari string "HH:mm"
  List<String> timeParts = time.split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1]);

  // Gabungkan tanggal hari ini dengan waktu yang diberikan
  DateTime dateTime = DateTime(now.year, now.month, now.day, hours, minutes);

  return dateTime;
}
