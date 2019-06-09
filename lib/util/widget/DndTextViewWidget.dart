import 'package:flutter/material.dart';

import 'package:dnd_headlines/res/Strings.dart';

/// Helper widget to include other material components 
/// wrapping the [Text].
class DndTextViewWidget extends StatelessWidget {

  final String text;

  DndTextViewWidget({@required this.text});

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
