extension DateStrExt on DateTime {
  String get numericDate => '$day/$month/$year';

  String get ageStr {
    final days = DateTime.now().difference(this).inDays;
    if (days == 0) return timeFormated;
    if (days == 1) return 'Yesterday';
    final day = toLocal().day;
    return '$day ${_getMonthStr(month)}';
  }

  String get datetimeFormated {
    final local = toLocal();
    final day = local.day;
    final month = local.month;
    final year = local.year;
    return '$timeFormated,  $day ${_getMonthStr(month)} $year';
  }

  String get timeFormated {
    final local = toLocal();
    final hr = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$hr:$min';
  }
}

String _getMonthStr(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'None';
  }
}
