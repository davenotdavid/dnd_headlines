class HelperFunctions {

  static String getTimeDifference(String otherTime) {
    try {
      final otherDateTime = DateTime.parse(otherTime);
      final timeDifference = DateTime.now().difference(otherDateTime);
      final days = timeDifference.inDays;
      if (days > 0) {
        return (days == 1) ? '$days day ago' : '$days days ago';
      }
      final hours = timeDifference.inHours;
      if (hours > 0) {
        return (hours == 1) ? '$hours hour ago' : '$hours hours ago';
      }
      final minutes = timeDifference.inMinutes;
      if (minutes > 0) {
        return (minutes == 1) ? '$minutes minute ago' : '$minutes minutes ago';
      }
      final seconds = timeDifference.inSeconds;
      if (seconds > 0) {
        return (seconds == 1) ? '$seconds second ago' : '$seconds seconds ago';
      }
    } on FormatException {
      print('Error formatting $otherTime');
    }

    return '';
  }

}
