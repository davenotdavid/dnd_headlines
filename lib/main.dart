import 'dart:convert';

import 'package:dnd_headlines/utils/dimens.dart';
import 'package:dnd_headlines/utils/helper_functions.dart';
import 'package:dnd_headlines/widgets/helper_progress_bar_widget.dart';
import 'package:dnd_headlines/widgets/helper_text_widget.dart';
import 'package:dnd_headlines/widgets/helper_article_webview_widget.dart';
import 'package:flutter/material.dart';
import 'package:dnd_headlines/utils/strings.dart';
import 'package:dnd_headlines/model/headline_response.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:dnd_headlines/utils/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.collections_bookmark),
            alignment: Alignment.centerRight,
            onPressed: () {
              _showPickerDialog(context);
            },
          )
        ],
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
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => 
                      HelperArticleWebViewWidget(article: article)
                    )
                  );
                },
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

  void _showPickerDialog(BuildContext context) async {
    final newsSources = await loadNewsSourcesJson(context);
    final sourceNames = newsSources.map((source) => source.name).toList();

    new Picker(
      adapter: PickerDataAdapter<String>(pickerdata: sourceNames),
      hideHeader: true,
      title: new Text(Strings.newsSourcePickerDialogTitle),
      onConfirm: (Picker picker, List value) {
        _onNewsSourceSelected(newsSources, value);
      }
    ).showDialog(context);
  }

  void _onNewsSourceSelected(List<Source> newsSources, List value) async {
    final sourceId = newsSources[value[0]].id;
    await setNewsSourcePrefId(sourceId);
    await getNewsSources()
        .then((headline) => this.headline.setHeadline(headline))
        .catchError((error) => print(error));
  }
}



/// TODO: Use `GestureDetector` widget for News API attribution image at the bottom



Future<List<Source>> loadNewsSourcesJson(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString('assets/news_sources.json');
  final jsonResult = json.decode(data);
  final newsSources = (jsonResult as List).map((e) => Source.fromJson(e)).toList();

  return newsSources;
}

Future<String> getNewsSourcePrefId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Strings.newsSourcePrefKey) ?? Strings.newsSourcePrefIdDefault;
}

Future<void> setNewsSourcePrefId(String sourceId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(Strings.newsSourcePrefKey, sourceId);
}

Future<Headline> getNewsSources() async {
  final sourceId = await getNewsSourcePrefId();
  final sourceList = [sourceId];
  final response = await client.request(TopHeadlines(
      sources: sourceList
  ));
  final headline = Headline.fromJson(response);
  headline.log();

  return headline;
}




