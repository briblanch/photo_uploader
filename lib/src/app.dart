import 'package:flutter/material.dart';
import 'package:photo_uploader/src/colors.dart';

import 'package:photo_uploader/src/photo_list.dart';

class PhotoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: workivaTheme,
      home: new PhotoList(),
    );
  }
}
