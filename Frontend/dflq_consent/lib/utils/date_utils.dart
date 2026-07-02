class AppDateUtils {
  const AppDateUtils._();

  static String formatDocumentDate(DateTime date) {
    final day = _twoDigits(date.day);
    final month = _twoDigits(date.month);
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  static String formatYearMonthFolder(DateTime date) {
    final year = date.year.toString();
    final month = _twoDigits(date.month);

    return '$year-$month';
  }

  static String formatFileDate(DateTime date) {
    final year = date.year.toString();
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);

    return '$year-$month-$day';
  }

  static String formatFileTime(DateTime date) {
    final hour = _twoDigits(date.hour);
    final minute = _twoDigits(date.minute);
    final second = _twoDigits(date.second);

    return '$hour-$minute-$second';
  }

  static String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}