import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:meme_generator/src/model.dart';

class MemeGrid extends StatefulWidget {
  @override
  _MemeGridState createState() => new _MemeGridState();
}

class _MemeGridState extends State<MemeGrid> {
  List<Meme> _memes = <Meme>[];
  StreamSubscription _memesSub;

  @override
  void initState() {
    super.initState();
    _fetchMemes();
  }

  @override
  void dispose() {
    super.dispose();
    _memesSub?.cancel();
  }

  Future<void> _fetchMemes() async {
    final snap = await Firestore.instance
        .collection('memes')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      _memes = snap.documents.map((d) => new Meme.fromJson(d.data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Memes'),
      ),
      body: new ListView.builder(
        itemCount: _memes.length,
        itemBuilder: (context, index) {
          return new Card(
            child: new Column(
              children: <Widget>[
                new Image.network(_memes[index].url),
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text('Posted on ${_memes[index].timestamp}'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
