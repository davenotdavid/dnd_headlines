import 'package:flutter/material.dart';

import 'package:dnd_headlines/res/Strings.dart';

/// Helper progress widget to include other material components 
/// wrapping the [CircularProgressIndicator].
class DndProgressIndicatorWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName)
      ),
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }

}
