import 'package:dnd_headlines/api/news_api_repository.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:dnd_headlines/widgets/helper_progress_bar_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_headlines/main.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements NewsApiRepository {}

void main() {
  group('Get top headlines from Google News to test out corresponding widgets', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        Strings.newsSourcePrefKey: 'google-news'
      });
    });

    testWidgets('loads and starts off with a progress bar', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 0, articles: []));

      await tester.pumpWidget(widget);
        
      expect(find.byType(HelperProgressBarWidget), findsOneWidget);
    });

    testWidgets('loads and shows headline article data', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 1, articles: [Article(title: 'Test Article Title', source: Source(id: 'google-news', name: 'Google News'), publishedAt: '2020-01-01T00:00:00+00:00')]));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsNothing);
      expect(find.text('Test Article Title'), findsOneWidget);
    });

    testWidgets('loads and shows empty state', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline(status: 'ok', totalResults: 0, articles: []));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsOneWidget);
    });

    testWidgets('loads and shows empty state from erroring out', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => throw 'Failed to load response');

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsOneWidget);
    });

  });

}
