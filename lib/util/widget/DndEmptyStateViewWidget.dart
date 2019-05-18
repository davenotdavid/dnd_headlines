import 'package:flutter/material.dart';

import 'package:dnd_headlines/res/Strings.dart';

/// Helper widget to include other material components 
/// wrapping the empty state [Text].
class DndEmptyStateViewWidget extends StatelessWidget {

  final String emptyText;

  DndEmptyStateViewWidget({@required this.emptyText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName)
      ),
      body: Center(
        child: Text(emptyText)
      ),
    );
  }

}
