// ignore_for_file: avoid_print
import 'package:date_format/date_format.dart';

class DateHelper {
  static String formatDateTime(DateTime date) {
    return formatDate(date, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
  }
}
