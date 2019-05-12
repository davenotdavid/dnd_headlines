import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:dnd_headlines/model/HeadlineResponse.dart';

WebViewController _controller;
class WebRoute extends StatelessWidget {

  final Article article;

  WebRoute({@required this.article});

  /// When returning a [Scaffold] here as part of this succeeding
  /// route, a platform-specific back button is automatically
  /// added onto the app bar, which would then call [Navigator.pop()].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: WebView(
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        initialUrl: article.url,
        javascriptMode: JavascriptMode.unrestricted
      )
    );
  }

}