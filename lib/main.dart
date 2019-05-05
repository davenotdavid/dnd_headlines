import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dnd_headlines/app/DndHeadlinesApp.dart';
import 'package:dnd_headlines/model/HeadlineResponse.dart';
import 'package:dnd_headlines/util/Constants.dart';
import 'package:dnd_headlines/util/HelperFunctions.dart';
import 'package:dnd_headlines/res/Strings.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:flutter_picker/flutter_picker.dart';

import 'package:newsapi_client/newsapi_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Class fields
String _newsApiKey;
String _sourceId;

void main() => runApp(DndHeadlinesRootWidget());

class DndHeadlinesRootWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Headline>(
        future: initDataAndGetHeadlines(),
        builder: (BuildContext context, AsyncSnapshot<Headline> snapshot) {
          if (snapshot.hasData) {
            return HeadlineWidget(headline: snapshot.data);
          } else if (snapshot.hasError) {
            return Center(child: Text(Strings.errorEmptyViewGetNewsSources));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Future<Headline> initDataAndGetHeadlines() async {
    final remoteConfig = await getRemoteConfig();
    _newsApiKey = remoteConfig.getString(Strings.newsApiKey);

    await getNewsSourcePrefId()
        .then((sourcePrefId) => _sourceId = sourcePrefId)
        .catchError((error) => DndHeadlinesApp.log(error));

    return getNewsSources(_newsApiKey, _sourceId);
  }

}

class HeadlineWidget extends AnimatedWidget {

  HeadlineWidget({this.headline}) : super(listenable: headline);

  final Headline headline;

  @override
  Widget build(BuildContext context) {
    final articles = headline.articles ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(headline.getPublisherName() ?? Strings.appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            alignment: Alignment.centerRight,
            onPressed: () {
              _showPickerDialog(context);
            },
          )
        ],
      ),
      body: articles.isNotEmpty 
        ? ListView.builder(
            itemCount: articles.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text(articles[index].title));
            }) 
        : Center(child: Text(Strings.errorEmptyViewGetNewsSources)),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            onRefreshFabClicked();
          }
      ),
    );
  }

  void _showPickerDialog(BuildContext context) async {
    final newsSources = List<Source>();
    await _loadNewsSourcesJson(context)
        .then((sources) => newsSources.addAll(sources))
        .catchError((error) => DndHeadlinesApp.log(error));

    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: HelperFunctions.getSourceNames(newsSources)),
        hideHeader: true,
        title: new Text(Strings.newsSourcePickerDialogTitle),
        onConfirm: (Picker picker, List value) {
          onNewsSourceSelected(newsSources, value);
        }
    ).showDialog(context);
  }

  void onNewsSourceSelected(List<Source> newsSources, List value) async {
    _sourceId = newsSources[value[0]].id;
    await setNewsSourcePrefId(_sourceId);

    await getNewsSources(_newsApiKey, _sourceId)
        .then((headline) => this.headline.setHeadline(headline))
        .catchError((error) => DndHeadlinesApp.log(error));
  }

  void onRefreshFabClicked() async {
    await getNewsSources(_newsApiKey, _sourceId)
        .then((headline) => this.headline.setHeadline(headline))
        .catchError((error) => DndHeadlinesApp.log(error));
  }

}

/// TODO: The following helper functions are used universally, so move them somewhere more reasonable (i.e. API interface, service layer, and etc.)

Future<List<Source>> _loadNewsSourcesJson(BuildContext context) async {
  String data = await DefaultAssetBundle.of(context).loadString(Strings.newsSourceJsonPath);
  final jsonResult = json.decode(data);
  final newsSources = (jsonResult as List).map((i) => Source.fromJson(i)).toList();

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

Future<Headline> getNewsSources(String apiKey, String sourceId) async {
  if (apiKey == null || apiKey.isEmpty) {
    /// Ensures that the empty view will be set from the
    /// calling widget via [Headline]'s listen notifier.
    return Headline(null, null, List<Article>());
  }

  /// JSON decoding occurs deep under the hood within the following
  /// News API package implementation.
  final client = NewsapiClient(apiKey);
  final sourceList = [sourceId ?? Strings.newsSourcePrefIdDefault];
  final response = await client.request(TopHeadlines(
      sources: sourceList, /// Source ID as the identifier
      pageSize: Constants.defaultPageSize
  ));
  final headline = Headline.fromJson(response);
  headline.log();

  return headline;
}

Future<RemoteConfig> getRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  /// Enables developer mode to relax fetch throttling.
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  remoteConfig.setDefaults(<String, dynamic>{
    Strings.newsApiKey: "",
  });

  try {
    /// Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
  } on FetchThrottledException catch (exception) {
    print(exception);
  } catch (exception) {
    print(Strings.errorMsgExceptionRemoteConfig);
  }

  return remoteConfig;
}
