import 'package:dnd_headlines/utils/dimens.dart';
import 'package:dnd_headlines/utils/helper_functions.dart';
import 'package:dnd_headlines/widgets/helper_progress_bar_widget.dart';
import 'package:dnd_headlines/widgets/helper_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:dnd_headlines/utils/keys.dart';

final client = NewsapiClient(Keys.NEWS_API_KEY);

void main() => runApp(DndHeadlinesMainWidget());

class DndHeadlinesMainWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FutureBuilder<Headline>(
        future: getNewsSources(),
        builder: (BuildContext context, AsyncSnapshot<Headline> snapshot) {
          if (snapshot.hasData) {
            return HeadlineWidget(headline: snapshot.data);
          } else if (snapshot.hasError) {
            return HelperTextWidget(text: Strings.errorEmptyStateViewGetNewsSources);
          } else {
            return HelperProgressBarWidget();
          }
        }
      ),
    );
  }
}


class HeadlineWidget extends AnimatedWidget {

  final Headline headline;

  HeadlineWidget({this.headline}) : super(listenable: headline);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(headline.getArticleSourceName() ?? Strings.appName),
      ),
      body: _getHeadlineListViewWidget(),
    );
  }
  
  Widget _getHeadlineListViewWidget() {
    final articles = headline.articles;

    return RefreshIndicator(
      child: articles.isNotEmpty
        ? ListView.builder(
          itemCount: articles.length,
          itemBuilder: (BuildContext context, int index) {
            final article = articles[index];
            
            return Card(
              child: ListTile(
                title: Text(article.title),
                subtitle: Text(HelperFunctions.getTimeDifference(article.publishedAt)),
                contentPadding: EdgeInsets.fromLTRB(
                  Dimens.paddingDefault,
                  (index == 0) ? Dimens.paddingOneHalf : 0.0,
                  Dimens.paddingDefault,
                  Dimens.paddingOneHalf
                ),
              ),
            );
          },
        )
        : Center(
            child: Text(Strings.errorEmptyStateViewGetNewsSources)
          ), 
      onRefresh: () async {
        await getNewsSources()
            .then((headline) => this.headline.setHeadline(headline))
            .catchError((error) => print(error));
      }
    );
  }
}



/// TODO: Handle tap logic to transition to webview (plugin) for article to open
/// TODO: Create a helper function for filtering article data with say, a null or blank title
/// TODO: As part of Scaffold widget, add an app bar with an action to handle a new source selection via `flutter_picker` plugin
/// TODO: With the picker dialog, handle logic for when a different new source is selected and then cache it
/// TODO: Use `GestureDetector` widget for News API attribution image at the bottom



/// TODO: Add a helper function to decode static JSON metadata file for a list of news sources returned

/// TODO: Add helper functions for handling caching logic for a selected news source

Future<Headline> getNewsSources() async {
  final sourceList = ['google-news'];
  final response = await client.request(TopHeadlines(
      sources: sourceList
  ));
  final headline = Headline.fromJson(response);
  headline.log();

  return headline;
}




