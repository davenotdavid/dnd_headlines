import 'package:dnd_headlines/model/headline_response.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelperArticleWebViewWidget extends StatelessWidget {

  final Article article;

  HelperArticleWebViewWidget({@required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title)
      ),
      body: Center(
        child: WebView(
          initialUrl: article.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
      ),
    );
  }

}
