import 'package:dnd_headlines/api/news_api_repository.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:dnd_headlines/widgets/helper_progress_bar_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dnd_headlines/main.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Finalize test file naming
/* TODO: Wrap with the following?
testWidgets('Navigate to landing page on correct login url',
  (WidgetTester tester) async {
  await tester.runAsync(() async {

    // test code here

  });
});
*/

class MockClient extends Mock implements NewsApiRepository {}

void main() {
  group('TODO: Get top headlines', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        Strings.newsSourcePrefKey: 'google-news'
      });
    });

    testWidgets('TODO: starts off with a progress bar', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline('ok', 0, []));

      await tester.pumpWidget(widget);
        
      expect(find.byType(HelperProgressBarWidget), findsOneWidget);
    });

    // TODO: Test for Headline widget

    // TODO: How about for forceful throwing like: `when(client.getTopHeadlines('google-news')).thenAnswer((_) async => throw 'Failed to load response');`
    testWidgets('TODO: loads and shows an error', (WidgetTester tester) async {
      final prefs = await SharedPreferences.getInstance();
      final client = MockClient();
      final widget = DndHeadlinesMainWidget(newsApiRepo: client);

      when(client.getTopHeadlines(prefs.getString(Strings.newsSourcePrefKey))).thenAnswer((_) async => Headline('ok', 0, []));

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // TODO: Successful response, but empty list so empty state
      expect(find.text(Strings.errorEmptyStateViewGetNewsSources), findsOneWidget);
    });

  });



}
