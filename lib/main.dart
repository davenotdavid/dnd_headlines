import 'dart:convert';

import 'package:dnd_headlines/res/Dimens.dart';
import 'package:flutter/material.dart';

import 'package:dnd_headlines/app/DndHeadlinesApp.dart';
import 'package:dnd_headlines/model/HeadlineResponse.dart';
import 'package:dnd_headlines/util/Constants.dart';
import 'package:dnd_headlines/util/HelperFunctions.dart';
import 'package:dnd_headlines/util/widget/DndTextViewWidget.dart';
import 'package:dnd_headlines/util/widget/DndProgressIndicatorWidget.dart';
import 'package:dnd_headlines/res/Strings.dart';

import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:newsapi_client/newsapi_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class fields
String _sourceId;

void main() => runApp(DndHeadlinesRootWidget());

/// Root widget responsible for laying out the home screen of the app. Aside 
/// from theme and styling, a [FutureBuilder] is used to reactively build out 
/// the widget as soon as the latest [AsyncSnapshot]'s tasks are completed 
/// (with the [Future] returned.
class DndHeadlinesRootWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FutureBuilder<Headline>(
        future: _initDataAndGetHeadlines(),
        builder: (BuildContext context, AsyncSnapshot<Headline> snapshot) {
          if (snapshot.hasData) {
            return HeadlineWidget(headline: snapshot.data);
          } else if (snapshot.hasError) {
            return DndTextViewWidget(text: Strings.errorEmptyStateViewGetNewsSources,);
          } else {
            return DndProgressIndicatorWidget();
          }
        }
      ),
    );
  }

  /// Inits field instances used throughout this app prior to retrieving headline 
  /// data during the initial session.
  Future<Headline> _initDataAndGetHeadlines() async {
    await getNewsSourcePrefId()
        .then((sourcePrefId) => _sourceId = sourcePrefId)
        .catchError((error) => DndHeadlinesApp.log(error));

    return getNewsSources(_sourceId);
  }

}

/// A subclass of the "listenable" widget, [AnimatedWidget], that rebuilds 
/// itself every time there's a diff between [Headline] data. This is 
/// possible since [Headline] implements a listenable.
class HeadlineWidget extends AnimatedWidget {

  final Headline headline;

  HeadlineWidget({this.headline}) : super(listenable: headline);

  /// Lays out the top [Headline] news data via a [ListView] should there be data,
  /// otherwise an empty view is shown. A user can also change the news publisher 
  /// (which will fire off the listener), or maybe refresh the data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(headline.getPublisherName() ?? Strings.appName),
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
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebviewScaffold(
                url: Strings.newsApiUrl,
                appBar: AppBar(title: Text(Strings.appName))
              )
            ),
          );
        },
        child: Image.asset(Strings.newsApiAttributionImgPath)),
    );
  }

  Widget _getHeadlineListViewWidget() {
    /// Retrieves the articles from the [Headline] listenable object, and then 
    /// filters out the articles that don't qualify with say, respective properties 
    /// that are either null or blank for instance.
    final articles = headline.articles ?? [];
    final filteredArticles = articles.where(((item) => (!(HelperFunctions.isNullOrBlank(item.title))))).toList();

    return RefreshIndicator(
      child: filteredArticles.isNotEmpty
        ? ListView.builder(
          itemCount: filteredArticles.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final article = filteredArticles[index];
            DndHeadlinesApp.log('Article: $article');
            
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
                      WebviewScaffold(
                        url: article.url,
                        appBar: AppBar(title: Text(article.title)),
                        clearCache: true,
                        appCacheEnabled: false,
                      )
                    )
                  );
                }
              ),
            );
          })
        : Center(child: Text(Strings.errorEmptyStateViewGetNewsSources)),
      onRefresh: () async {
        await getNewsSources(_sourceId)
            .then((headline) => this.headline.setHeadline(headline))
            .catchError((error) => DndHeadlinesApp.log(error));
      }
    );
  }

  /// Displays a [Picker] dialog of a list of news publisher options after 
  /// decoding the news source JSON metadata.
  void _showPickerDialog(BuildContext context) async {
    final newsSources = List<Source>();
    await loadNewsSourcesJson(context)
        .then((sources) => newsSources.addAll(sources))
        .catchError((error) => DndHeadlinesApp.log(error));

    new Picker(
      adapter: PickerDataAdapter<String>(pickerdata: HelperFunctions.getSourceNames(newsSources)),
      hideHeader: true,
      title: new Text(Strings.newsSourcePickerDialogTitle),
      onConfirm: (Picker picker, List value) {
        _onNewsSourceSelected(newsSources, value);
      }
    ).showDialog(context);
  }

  /// Handles the news publisher selected from the [Picker] such as retrieving 
  /// [Headline] data with the selected source's ID (and sets and caches it), and 
  /// then rebuilds this widget with new data.
  void _onNewsSourceSelected(List<Source> newsSources, List value) async {
    _sourceId = newsSources[value[0]].id;
    await setNewsSourcePrefId(_sourceId);

    await getNewsSources(_sourceId)
        .then((headline) => this.headline.setHeadline(headline))
        .catchError((error) => DndHeadlinesApp.log(error));
  }

}

/// TODO: The following helper functions are used universally, so move them somewhere more reasonable (i.e. API interface, service layer, and etc.)

/// Returns a list of [Source]s after decoding the static JSON metadata file.
Future<List<Source>> loadNewsSourcesJson(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString(Strings.newsSourceJsonPath);
  final jsonResult = json.decode(data);
  final newsSources = (jsonResult as List).map((i) => Source.fromJson(i)).toList();

  return newsSources;
}

/// Returns the cached news source publisher ID.
Future<String> getNewsSourcePrefId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(Strings.newsSourcePrefKey) ?? Strings.newsSourcePrefIdDefault;
}

/// Caches the news source publisher ID for future sessions.
Future<void> setNewsSourcePrefId(String sourceId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(Strings.newsSourcePrefKey, sourceId);
}

/// GET call for news source data.
Future<Headline> getNewsSources(String sourceId) async {
  /// JSON decoding occurs deep under the hood within the following News API 
  /// package implementation.
  final client = NewsapiClient(Strings.newsApiKey);
  final sourceList = [sourceId ?? Strings.newsSourcePrefIdDefault];
  final response = await client.request(TopHeadlines(
      sources: sourceList, /// Source ID as the identifier
      pageSize: Constants.defaultPageSize
  ));
  final headline = Headline.fromJson(response);
  headline.log();

  return headline;
}
