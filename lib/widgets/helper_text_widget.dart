import 'package:flutter/material.dart';

import 'package:dnd_headlines/utils/strings.dart';

class HelperTextWidget extends StatelessWidget {

  final String text;

  HelperTextWidget({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName)
      ),
      body: Center(
        child: Text(text)
      ),
    );
  }

}
