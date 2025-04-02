//helper functions to get the correct formatting for the date on the dashboard
import 'package:intl/intl.dart';

class DateFormatter {
  //get the appropriate suffix for the day
  static String getDaySuffix(int day) {
    if (day >= 11 && day <=13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
  //format the date to the format desired
  static String formatDate(DateTime date) {
    final day = date.day;
    final suffix = getDaySuffix(day);
    return '$day$suffix ${DateFormat('MMM, y').format(date)}';
  }
}