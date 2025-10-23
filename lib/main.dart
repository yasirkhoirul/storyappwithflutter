import 'package:flutter/material.dart';

import 'package:story_app/screen/upload_screen.dart';
import 'package:story_app/theme/theme.dart';
import 'package:story_app/theme/util.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto Flex");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      // home: LoginScreen(signintap: () {})
      home: UploadScreen(),
      );
  }
}
