import 'package:dnd_headlines/main.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/keys.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final client = NewsapiClient(Keys.NEWS_API_KEY);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Get Top Headlines', () {
    test('response is a Headline type', () async {
      final response = await getNewsSources(client);

      expect(response, isA<Headline>());
    });
  });
}
