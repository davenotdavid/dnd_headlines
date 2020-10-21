import 'package:flutter/foundation.dart';

import 'package:dnd_headlines/app/dnd_headlines_app.dart';
import 'package:dnd_headlines/res/strings.dart';

/// Root response serialization model (for headline data from the News API 
/// package) that's a subclass of [ChangeNotifier] that listens for changes 
/// in headline data used in widgets, and then re-binds the widget tree if 
/// there's really a diff.
class Headline extends ChangeNotifier {

  String status;
  int totalResults;
  List<Article> articles;

  Headline(this.status, this.totalResults, this.articles);

  /// Native way in Flutter (as of writing this) of de-serializing.
  Headline.fromJson(Map<String, dynamic> json) :
        status = json['status'],
        totalResults = json['totalResults'],
        articles = (json['articles'] as List).map((e) => Article.fromJson(e)).toList();

  /// Native way in Flutter (as of writing this) of serializing.
  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalResults': totalResults,
        'articles': articles
      };

  /// Helper function used to retrieve a news source publisher's name (i.e.
  /// Google News).
  String getPublisherName() {
    try {
      var article = articles.first;
      var sourceName = article.source.name;
      return sourceName;
    } on StateError {
      DndHeadlinesApp.log(Strings.errorMsgHeadlinePublisherName);
    }

    return null;
  }

  /// Notifies all registered listeners only if there's a diff between an existing
  /// [Headline] object and the following object param.
  void setHeadline(Headline headline) async {
    status = headline.status;
    totalResults = headline.totalResults;
    articles = headline.articles;

    notifyListeners();
  }

  void log() {
    print('{\"status\": \"$status\", \"totalResults\": $totalResults, '
        '\"articles\": $articles}');
  }

}

/// Child response serialization model
class Article {

  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt; /// UTC format
  final String content;

  Article(this.source, this.author, this.title, this.description, this.url,
          this.urlToImage, this.publishedAt, this.content);

  Article.fromJson(Map<String, dynamic> json) :
        source = Source.fromJson(json['source'] as Map),
        author = json['author'],
        title = json['title'],
        description = json['description'],
        url = json['url'],
        urlToImage = json['urlToImage'],
        publishedAt = json['publishedAt'],
        content = json['content'];

  @override
  String toString() {
    return '{\"source\": $source, \"author\": \"$author\", \"title\": '
        '\"$title\", \"description\": \"$description\", \"url\": \"$url\", '
        '\"urlToImage\": \"$urlToImage\", \"publishedAt\": \"$publishedAt\", '
        '\"content\": \"$content\"}';
  }

}

/// Child response serialization model
class Source {

  final String id;
  final String name;

  Source(this.id, this.name);

  Source.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'];

  @override
  String toString() {
    return '{\"id\": \"$id\", \"name\": \"$name\"}';
  }

}
