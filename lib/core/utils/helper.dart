import 'package:intl/intl.dart';

abstract class Helper {
  static String formatTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
