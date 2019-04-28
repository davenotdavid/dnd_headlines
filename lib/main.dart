import 'package:flutter/material.dart';

import 'package:dnd_headlines/app/DndHeadlinesApp.dart';
import 'package:dnd_headlines/models/HeadlineResponse.dart';
import 'package:dnd_headlines/res/Constants.dart';
import 'package:dnd_headlines/res/Strings.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:newsapi_client/newsapi_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';

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
        future: getNewsSources(),
        builder: (BuildContext context, AsyncSnapshot<Headline> snapshot) {
          if (snapshot.hasData) {
            return HeadlineWidget(headline: snapshot.data);
          } else if (snapshot.hasError) {
            return Center(child: Text(Strings.errorMsgGetNewsSources));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

}

Future<String> getNewsPrefValue() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString(Strings.newsSourcePrefKey) ?? Strings.newsSourcePublisherDefault;
}

Future<Headline> getNewsSources() async {
  var remoteConfig = await getRemoteConfig();

  var apiKey = remoteConfig.getString(Strings.newsApiKey);
  var client = NewsapiClient(apiKey);
  var sourceList = [Strings.newsSourcePublisherDefault];
  await getNewsPrefValue()
      .then((value) => sourceList[0] = value)
      .catchError((error) => DndHeadlinesApp.log(error));

  /// JSON decoding occurs deep under the hood within the following
  /// News API package implementation.
  final response = await client.request(TopHeadlines(
      sources: sourceList,
      pageSize: Constants.defaultPageSize
  ));
  var headline = Headline.fromJson(response);
  headline.log();

  return headline;
}

Future<RemoteConfig> getRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  /// Enables developer mode to relax fetch throttling.
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  remoteConfig.setDefaults(<String, dynamic>{
    Strings.newsApiKey: 'Error',
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

class HeadlineWidget extends AnimatedWidget {

  HeadlineWidget({this.headline}) : super(listenable: headline);

  final Headline headline;

  @override
  Widget build(BuildContext context) {
    var articles = headline.articles ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(headline.getPublisherName() ?? Strings.appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            alignment: Alignment.centerRight,
            onPressed: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingsRoute())
              );
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
        : Center(child: Text('No articles found')),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () async {
            await getNewsSources()
                .then((headline) => this.headline.setHeadline(headline))
                .catchError((error) => DndHeadlinesApp.log(error));
          }
      ),
    );
  }
}
