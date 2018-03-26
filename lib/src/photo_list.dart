import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo.dart';
import 'package:photo_uploader/src/uploader.dart';

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => new _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  List<Photo> _photos = <Photo>[];
  StreamSubscription _photosSub;

  @override
  void initState() {
    super.initState();

    // Listen for the photos ref for events in our firestore
    _photosSub = Firestore.instance
        .collection('photos')
        .limit(50)
        .orderBy('timestamp', descending: true)
        .snapshots
        .listen(_onPhotosRecieved);
  }

  @override
  void dispose() {
    super.dispose();
    _photosSub?.cancel();
  }

  void _onPhotosRecieved(QuerySnapshot snap) {
    setState(() {
      _photos = snap.documents.map((d) => new Photo.fromJson(d.data)).toList();
    });
  }

  void _onFABTapped() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (_) => new PhotoUploader(),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildCard(Photo photo) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Card(
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                decoration: new BoxDecoration(
                  border: new Border.all(
                    color: Theme.of(context).canvasColor,
                    width: 5.0,
                  ),
                ),
                child: new Image.network(
                  photo.url,
                ),
              ),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                      photo.title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Text('${photo.displayDateString}',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            ),
            photo.description != null
                ? new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: new Text(photo.description),
                        ),
                      )
                    ],
                  )
                : new Container()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photos'),
      ),
      body: new Container(
        child: new ListView.builder(
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            final photo = _photos[index];

            return _buildCard(photo);
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: _onFABTapped,
      ),
    );
  }
}
