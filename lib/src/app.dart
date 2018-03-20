import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo_grid.dart';

class PhotoUploaderApp extends StatelessWidget {
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
