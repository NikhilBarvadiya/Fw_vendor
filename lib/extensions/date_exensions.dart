import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

String getFormattedDate(String dtStr) {
  var dt = DateTime.parse(dtStr);

  return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
}

String getFormattedDate2(String dtStr) {
  return DateFormat('dd MMM yyyy', 'en_US').format(DateTime.parse(dtStr));
}
