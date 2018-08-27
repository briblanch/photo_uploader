import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:photo_uploader/src/photo.dart';
import 'package:photo_uploader/src/uploader.dart';

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
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
        .snapshots()
        .listen(_onPhotosRecieved);
  }

  @override
  void dispose() {
    super.dispose();
    _photosSub?.cancel();
  }

  void _onPhotosRecieved(QuerySnapshot snap) {
    setState(() {
      _photos = snap.documents.map((d) => Photo.fromJson(d.data)).toList();
    });
  }

  void _onFABTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoUploader(),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildCard(Photo photo) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).canvasColor,
                    width: 5.0,
                  ),
                ),
                child: Image.network(
                  photo.url,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      photo.title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('${photo.displayDateString}',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            ),
            photo.description != null
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(photo.description),
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            final photo = _photos[index];

            return _buildCard(photo);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onFABTapped,
      ),
    );
  }
}
