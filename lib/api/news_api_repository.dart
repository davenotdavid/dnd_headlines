import 'package:dnd_headlines/model/headline_response.dart';
import 'package:dnd_headlines/utils/keys.dart';
import 'package:newsapi_client/newsapi_client.dart';

class NewsApiRepository {

  final client = NewsapiClient(Keys.NEWS_API_KEY);

  Future<Headline> getTopHeadlines(String sourceId) async {
    final response = await client.request(TopHeadlines(
        sources: [sourceId]
    ));
    final headline = Headline.fromJson(response);
    headline.log();

    return headline;
  }

}
