import 'package:flutter/material.dart';

class Headline extends ChangeNotifier {

  String status;
  int totalResults;
  List<Article> articles;

  Headline({this.status, this.totalResults, this.articles});

  Headline.fromJson(Map<String, dynamic> json) :
        status = json['status'],
        totalResults = json['totalResults'],
        articles = (json['articles'] as List).map((e) => Article.fromJson(e)).toList();

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalResults': totalResults,
        'articles': articles
      };

  String getArticleSourceName() {
    try {
      var article = articles.first;
      var sourceName = article.source.name;
      return sourceName;
    } on StateError {
      print('Error retrieving Headline object publisher\'s name.');
    }

    return null;
  }

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

class Article {

  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt; /// UTC format
  final String content;

  Article({this.source, this.author, this.title, this.description, this.url,
          this.urlToImage, this.publishedAt, this.content});

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

class Source {

  final String id;
  final String name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'];

  @override
  String toString() {
    return '{\"id\": \"$id\", \"name\": \"$name\"}';
  }

}
