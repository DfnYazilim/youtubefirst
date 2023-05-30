import 'package:intl/intl.dart';

extension KapoExts on String? {
  String mongoDateTime() {
    if (this == null) return "-";
    return DateFormat('dd.MM.yyyy HH:mm').format(
        DateFormat("yyyy-MM-ddThh:mm:ssZ").parseUTC(this!).toLocal());
  }
}