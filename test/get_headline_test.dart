import 'package:dnd_headlines/main.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/keys.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Refactor to actually mock out API for responses to test out
// TODO: Probably include `shared_preferences` in this test file as well?
void main() {
  // final client = NewsapiClient(Keys.NEWS_API_KEY);

  // // group('Get top headlines without cached source pref ID', () {
  //   setUp(() {
  //     SharedPreferences.setMockInitialValues({});
  //   });

  //   test('decoded JSON response has article data', () async {
  //     final response = await client.request(TopHeadlines(
  //       sources: ['google-news']
  //     ));

  //     expect(response, contains('articles'));
  //   });

  //   test('deserialized response is a Headline type', () async {
  //     final response = await getNewsSources(client);

  //     expect(response, isA<Headline>());
  //   });

  //   test('headline\'s article source name matches', () async {
  //     final response = await getNewsSources(client);

  //     expect(response.getArticleSourceName(), 'Google News');
  //   });
  // });

  // group('Get top headlines with cached source pref ID', () {
  //   setUp(() {
  //     SharedPreferences.setMockInitialValues({
  //       Strings.newsSourcePrefKey: 'ars-technica'
  //     });
  //   });

  //   test('deserialized response is a Headline type', () async {
  //     final response = await getNewsSources(client);

  //     expect(response, isA<Headline>());
  //   });

  //   test('headline\'s article source name matches', () async {
  //     final response = await getNewsSources(client);

  //     expect(response.getArticleSourceName(), 'Ars Technica');
  //   });
  // });
}
