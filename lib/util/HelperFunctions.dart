import 'package:dnd_headlines/app/DndHeadlinesApp.dart';
import 'package:dnd_headlines/model/HeadlineResponse.dart';

/// Disclaimer: Extension functions not supported yet as of Dart 2

class HelperFunctions {

  static List<String> getSourceNames(List<Source> sources) {
    final sourceNames = new List<String>();
    sources.forEach((source) => sourceNames.add(source.name));

    return sourceNames;
  }

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
        return (seconds == 1) ? '$seconds second' : '$seconds seconds';
      }
    } on FormatException {
      DndHeadlinesApp.log('Error formatting $otherTime');
    }

    return '';
  }

  /// Attempt to make this non-extension function 'Kotlin-like'.
  /// Also, note that the News API returns null values as a 
  /// string.
  static bool isNullOrBlank(String str) {
    return str == null || str == 'null' || str.trim().isEmpty;
  }

}