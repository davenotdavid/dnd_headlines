import 'package:dnd_headlines/api/news_api_repository.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_headlines/main.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements NewsApiRepository {}

void main() {
  group('Use loaded headline article data to test out widget interactions', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        Strings.newsSourcePrefKey: 'google-news'
      });
    });

    testWidgets('taps on a loaded article item to view its webview', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'Test Article Title', source: Source(id: 'google-news', name: 'Google News'), publishedAt: '2020-01-01T00:00:00+00:00', url: 'https://www.google.com')]));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      
      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsNothing);
      expect(find.text('Test Article Title'), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'Test Article Title'));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('helper_webview_widget')), findsOneWidget);
    });

    // TODO: More, more, and MORE!!!

  });

}
