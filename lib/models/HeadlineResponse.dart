import 'package:flutter/foundation.dart';

/**
 * Sample headline response from the News API package client:
    {
      "status": "ok",
      "totalResults": 10,
      "articles": [
        {
          "source": {
            "id": "bbc-news",
            "name": "BBC News"
          },
          "author": "BBC News",
          "title": "Wife admits killing Ku Klux Klan chief",
          "description": "Malissa Ancona is sentenced to life in jail for shooting her husband, Frank, in Missouri.",
          "url": "http://www.bbc.co.uk/news/world-us-canada-47996476",
          "urlToImage": "https://ichef.bbci.co.uk/news/1024/branded_news/8F4A/production/_106528663_08eb037e-d787-472b-a7df-c845a3e6a6c2.jpg",
          "publishedAt": "2019-04-20T10:48:24Z",
          "content": "Image copyrightSt Francois County SheriffImage caption\r\n Malissa Ancona was sentenced to life after admitting second-degree murder\r\nThe wife of a Ku Klux Klan leader in the US state of Missouri has admitted shooting him dead two years ago.\r\nMalissa Ancona, 47… [+1389 chars]"
        },
        {
          "source": {
            "id": "bbc-news",
            "name": "BBC News"
          },
          "author": "BBC News",
          "title": "Ministry building under attack in Kabul",
          "description": "Explosion and gunfire heard in Afghan capital Kabul as ministry of information HQ comes under attack",
          "url": "http://www.bbc.co.uk/news/world-asia-47996762",
          "urlToImage": "https://ichef.bbci.co.uk/news/1024/branded_news/7A23/production/_97176213_breaking_news_bigger.png",
          "publishedAt": "2019-04-20T08:06:40Z",
          "content": "An explosion and gunfire have been heard in the Afghan capital Kabul as the ministry of information HQ comes under attack.\r\nThe explosion was heard at around 11:40 local time (07:10 GMT), ministry spokesperson Nasrat Rahimi said.\r\nThis breaking news story is … [+254 chars]"
        }
      ]
    }
 */

/// Root response serialization model (for headline data
/// from the News API package) that's a subclass of
/// [ChangeNotifier] that listens for changes in headline
/// data used in widgets, and then re-binds the widget tree
/// if there's really a diff.
class Headline extends ChangeNotifier {

  String status;
  int totalResults;
  List<Article> articles;

  Headline(this.status, this.totalResults, this.articles);

  /// Native way in Flutter (as of writing this) of de-serializing.
  Headline.fromJson(Map<String, dynamic> json) :
        status = json['status'],
        totalResults = json['totalResults'],
        articles = (json['articles'] as List).map((i) => Article.fromJson(i)).toList();

  /// Native way in Flutter (as of writing this) of serializing.
  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalResults': totalResults,
        'articles': articles
      };

  /// Notifies all registered listeners only if there's a diff
  /// between an existing [Headline] object and the following
  /// object param.
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