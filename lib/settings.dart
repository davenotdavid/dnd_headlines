import 'package:flutter/material.dart';

import 'res/Strings.dart';

class SettingsRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.appBarTitleSettings)),
    );
  }

}