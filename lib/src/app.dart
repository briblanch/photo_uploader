import 'package:flutter/material.dart';

import 'package:meme_generator/src/creator.dart';
import 'package:meme_generator/src/meme_grid.dart';

class MemeGeneratorApp extends StatefulWidget {
  final pages = [
    new BottomNavigationBarItem(
      title: new Text('Memes'),
      icon: new Icon(Icons.photo),
    ),
    new BottomNavigationBarItem(
      title: new Text('Create'),
      icon: new Icon(Icons.create),
    ),
  ];

  @override
  _MemeGeneratorAppState createState() => new _MemeGeneratorAppState();
}

class _MemeGeneratorAppState extends State<MemeGeneratorApp> {
  int _index = 0;

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return new MemeGrid();
      case 1:
        return new Creator();
      default:
        return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Colors.blueAccent,
        brightness: Brightness.dark,
      ),
      home: new Scaffold(
        body: _buildBody(),
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _index,
          items: widget.pages,
          onTap: (newIndex) {
            setState(() {
              _index = newIndex;
            });
          },
        ),
      ),
    );
  }
}
