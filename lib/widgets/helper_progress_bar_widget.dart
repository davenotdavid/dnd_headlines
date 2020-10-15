import 'package:dnd_headlines/utils/strings.dart';
import 'package:flutter/material.dart';

class HelperProgressBarWidget extends StatelessWidget {

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
