import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo_list.dart';

class PhotoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.blueAccent,
        brightness: Brightness.light,
        cardColor: Colors.pink.shade50,
      ),
      home: new PhotoList(),
    );
  }
}
