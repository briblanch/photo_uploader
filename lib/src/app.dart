import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo_grid.dart';

class PhotoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      home: PhotoGrid(),
    );
  }
}
