import 'package:intl/intl.dart';

class DateGroup<T> {
  final DateTime date;
  final bool open;
  final List<T> children;

  humanizeDate() {
    if (DateTime.now().difference(date).inDays == 0) {
      return 'Hari ini';
    } else if (DateTime.now().difference(date).inDays == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  static String humanizeDates(DateTime date) {
    if (DateTime.now().difference(date).inDays == 0) {
      return 'Hari ini';
    } else if (DateTime.now().difference(date).inDays == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  static String humanizeDateTimes(DateTime date) {
    if (DateTime.now().difference(date).inDays == 0) {
      if (DateTime.now().difference(date).inHours == 0) {
        if (DateTime.now().difference(date).inMinutes == 0) {
          return 'Sekarang';
        } else {
          return '${DateTime.now().difference(date).inMinutes} menit lalu';
        }
      } else {
        return '${DateTime.now().difference(date).inHours} jam lalu';
      }
    } else if (DateTime.now().difference(date).inDays == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  DateGroup({required this.date, required this.children, this.open = true});
}
