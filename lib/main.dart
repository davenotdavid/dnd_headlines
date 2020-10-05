import 'package:flutter/material.dart';
import 'package:dnd_headlines/utils/Strings.dart';
import 'package:dnd_headlines/model/HeadlineResponse.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:dnd_headlines/utils/Keys.dart';

void main() => runApp(DndHeadlinesMainWidget());

class DndHeadlinesMainWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      /// TODO: Set up logic for computed data from newly created `FutureBuilder` to render respective widgets (i.e. data, empty state, and progress bar)
      home: FutureBuilder<Headline>(
        future: getNewsSources(),
        builder: (BuildContext context, AsyncSnapshot<Headline> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.log();
            return Center(child: Text("Success!"),);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error..."),);
          } else {
            return Center(child: Text("Loading..."),);
          }
        }
      ),
    );
  }
}




/// TODO: Add stateful widget that reactively rebuilds itself each time data changes
/// TODO: Place headline article data in list view widget as part of Scaffold body param
/// TODO: Handle tap logic to transition to webview (plugin) for article to open
/// TODO: Wrap list view widget (and empty state text) in `RefreshIndicator` widget with refresh logic
/// TODO: Create a helper function for time difference logic as subtitle text for each article list card
/// TODO: Create a helper function for filtering article data with say, a null or blank title
/// TODO: As part of Scaffold widget, add an app bar with a title and an action to handle a new source selection via `flutter_picker` plugin
/// TODO: With the picker dialog, handle logic for when a different new source is selected and then cache it
/// TODO: Use `GestureDetector` widget for News API attribution image at the bottom




/// TODO: Add a helper function to decode static JSON metadata file for a list of news sources returned

/// TODO: Add helper functions for handling caching logic for a selected news source

Future<Headline> getNewsSources() async {
  final client = NewsapiClient(Keys.NEWS_API_KEY);
  final sourceList = ['google-news'];
  final response = await client.request(TopHeadlines(
      sources: sourceList,
      pageSize: 10
  ));
  final headline = Headline.fromJson(response);
  headline.log();

  return headline;
}




