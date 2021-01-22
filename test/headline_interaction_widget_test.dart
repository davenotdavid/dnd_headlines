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

      expect(find.byKey(Key(Strings.keyWidgetHelperWebview)), findsOneWidget);
    });

    testWidgets('swipe list view to refresh article data', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'Test Article Title', source: Source(id: 'google-news', name: 'Google News'), publishedAt: '2020-01-01T00:00:00+00:00', url: 'https://www.google.com')]));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      
      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsNothing);
      expect(find.text('Test Article Title'), findsOneWidget);

      await tester.drag(find.byKey(Key(Strings.keyWidgetRefreshIndicatorHeadline)), Offset(0.0, 500.0));

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'NEW Test Article Title', source: Source(id: 'google-news', name: 'Google News'), publishedAt: '2020-01-01T00:00:00+00:00', url: 'https://www.google.com')]));

      await tester.pumpAndSettle();

      expect(find.text('NEW Test Article Title'), findsOneWidget);
    });

    testWidgets('select diff news source from picker dialog widget', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'Test Article Title', source: Source(id: 'google-news', name: 'Google News'), publishedAt: '2020-01-01T00:00:00+00:00', url: 'https://www.google.com')]));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      
      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsNothing);
      expect(find.text('Test Article Title'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.collections_bookmark));
      await tester.pumpAndSettle();

      when(client.getTopHeadlines('abc-news')).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'ABC News: Test Article Title', source: Source(id: 'abc-news', name: 'ABC News'), publishedAt: '2020-01-01T00:00:00+00:00', url: 'https://abcnews.com')]));

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('ABC News: Test Article Title'), findsOneWidget);
    });

  });

}
