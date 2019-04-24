import 'package:flutter/material.dart';

import 'res/Strings.dart';

class SettingsRoute extends StatelessWidget {

  /// When returning a [Scaffold] here as part of this succeeding
  /// route, a platform-specific back button is automatically
  /// added onto the app bar, which would then call [Navigator.pop()].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Strings.appBarTitleSettings)),
    );
  }

}