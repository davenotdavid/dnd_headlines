import 'package:dnd_headlines/api/news_api_repository.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final newsApiRepo = NewsApiRepository();

  group('Get top headlines for Google News from cached source pref ID', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        Strings.newsSourcePrefKey: 'google-news'
      });
    });

    test('deserializing response to Headline type', () async {
      final prefs = await SharedPreferences.getInstance();
      final response = await newsApiRepo.getTopHeadlines((prefs.getString(Strings.newsSourcePrefKey)));

      expect(response, isA<Headline>());
    });

    test('headline\'s article source name matches', () async {
      final prefs = await SharedPreferences.getInstance();
      final response = await newsApiRepo.getTopHeadlines((prefs.getString(Strings.newsSourcePrefKey)));

      expect(response.getArticleSourceName(), 'Google News');
    });
  });

  group('Get top headlines for Ars Technica from cached source pref ID', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        Strings.newsSourcePrefKey: 'ars-technica'
      });
    });

    test('deserializing response to Headline type', () async {
      final prefs = await SharedPreferences.getInstance();
      final response = await newsApiRepo.getTopHeadlines((prefs.getString(Strings.newsSourcePrefKey)));

      expect(response, isA<Headline>());
    });

    test('headline\'s article source name matches', () async {
      final prefs = await SharedPreferences.getInstance();
      final response = await newsApiRepo.getTopHeadlines((prefs.getString(Strings.newsSourcePrefKey)));

      expect(response.getArticleSourceName(), 'Ars Technica');
    });
  });
}
