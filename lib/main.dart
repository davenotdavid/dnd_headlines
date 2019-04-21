import 'package:flutter/material.dart';

import 'package:dnd_headlines/app/DndHeadlinesApp.dart';
import 'package:dnd_headlines/models/HeadlineResponse.dart';
import 'package:dnd_headlines/res/Strings.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:newsapi_client/newsapi_client.dart';

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
          return snapshot.hasData
              ? HeadlineWidget(headline: snapshot.data)
              : Container();
        }
      ),
    );
  }

}

Future<Headline> getNewsSources() async {
  var remoteConfig = await getRemoteConfig();

  var apiKey = remoteConfig.getString(Strings.newsApiKey);
  var client = NewsapiClient(apiKey);
  var sourceList = ['fox-news'];

  /// JSON decoding occurs deep under the hood within the following
  /// News API package implementation.
  final response = await client.request(TopHeadlines(
      sources: sourceList,
      pageSize: 10
  ));
  var headline = Headline.fromJson(response);
  //print(headline); TODO: Replace this with a log

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
        title: Text(Strings.appName),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          /// TODO: Empty state view
          return articles.isNotEmpty
              ? ListTile(title: Text(articles[index].title))
              : Center(child: Text('No articles found'));
        },
      ),
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
