import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo_grid.dart';

class PhotoUploaderApp extends StatefulWidget {
  @override
  _PhotoUploaderAppState createState() => new _PhotoUploaderAppState();
}

class _PhotoUploaderAppState extends State<PhotoUploaderApp> {
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
