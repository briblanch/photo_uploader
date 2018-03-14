import 'package:flutter/material.dart';

import 'package:meme_generator/src/photo_grid.dart';

class MemeGeneratorApp extends StatefulWidget {
  @override
  _MemeGeneratorAppState createState() => new _MemeGeneratorAppState();
}

class _MemeGeneratorAppState extends State<MemeGeneratorApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      home: new PhotoGrid(),
    );
  }
}
