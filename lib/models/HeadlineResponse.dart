class HeadlineResponse {

  final String status;
  final int totalResults;
  final List<Article> articles;

  HeadlineResponse(this.status, this.totalResults, this.articles);

  HeadlineResponse.fromJson(Map<String, dynamic> json) :
        status = json['status'],
        totalResults = json['totalResults'],
        articles = (json['articles'] as List).map((i) => Article.fromJson(i)).toList();

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalResults': totalResults,
        'articles': articles
      };

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

}

class Source {

  final String id;
  final String name;

  Source(this.id, this.name);

  Source.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'];

}