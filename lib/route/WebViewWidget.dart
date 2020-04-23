import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dnd_headlines/res/Strings.dart';

//WebViewController _controller;
class WebViewWidget extends StatelessWidget {

  final String url;

  WebViewWidget({@required this.url});

  /// When returning a [Scaffold] here as part of this succeeding route, a 
  /// platform-specific back button is automatically added onto the app bar, 
  /// which would then call [Navigator.pop()].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.appName)),
      body: WebView(
        /* onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        }, */
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted
      )
    );
  }

}
