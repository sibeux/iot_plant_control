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
