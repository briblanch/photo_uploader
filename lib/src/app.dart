import 'package:flutter/material.dart';
import 'package:photo_uploader/src/colors.dart';

import 'package:photo_uploader/src/photo_list.dart';

class PhotoUploaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: workivaGreen,
        primaryColorBrightness: Brightness.dark,
        canvasColor: canvasColor,
        accentColor: accentGreen,
        accentColorBrightness: Brightness.dark,
        cardColor: workivaCards,
      ),
      home: PhotoList(),
    );
  }
}
