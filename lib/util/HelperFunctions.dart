import 'package:dnd_headlines/model/HeadlineResponse.dart';

/// Extension functions not supported yet as of Dart 2

class HelperFunctions {

  static List<String> getSourceNames(List<Source> sources) {
    final sourceNames = new List<String>();
    sources.forEach((source) => sourceNames.add(source.name));

    return sourceNames;
  }

}