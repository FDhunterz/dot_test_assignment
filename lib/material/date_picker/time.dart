import 'package:intl/intl.dart';

extension DateFormater on DateTime {
  DateTime pst() {
    return toUtc().utcToLocal()!;
  }

  DateTime? utcToLocal() {
    final date = this;
    const pdtOffset = Duration(hours: -7);

    // Konversi ke PDT
    final pdtDateTime = date.toUtc().add(pdtOffset);

    return pdtDateTime;
  }

  localizedEEEEDDMMMMY() {
    return '${DateFormat.EEEE('id_ID').format(this)}, ${DateFormat.d('id_ID').format(this)} ${DateFormat.MMMM('id_ID').format(this)} ${DateFormat.y().format(this)}';
  }

  DateTime removeTime() {
    return DateTime(year, month, day);
  }
}
