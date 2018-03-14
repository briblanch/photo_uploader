import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:photo_uploader/src/photo.dart';

class PhotoUploader extends StatefulWidget {
  @override
  _PhotoUploaderState createState() => new _PhotoUploaderState();
}

class _PhotoUploaderState extends State<PhotoUploader> {
  bool _uploading = false;
  File _photo;
  String _title;
  String _description;

  Future<void> _onChooseImage() async {
    final pickedImage =
        await ImagePicker.pickImage(maxHeight: 500.0, maxWidth: 500.0);

    setState(() {
      _photo = pickedImage;
    });
  }

  Future<void> _uploadPhoto() async {
    setState(() {
      _uploading = true;
    });

    // Upload the chosen photo
    final task = FirebaseStorage.instance
        .ref()
        .child('photos/${new Uuid().v4()}.jpg')
        .put(_photo);

    // Wait for the upload to finish and retrieve the download url
    final downloadUrl = (await task.future).downloadUrl;

    final photo = new Photo(
      downloadUrl.toString(),
      _title,
      _description,
      new DateTime.now().toUtc(),
    );

    // Upload our photo to the photos ref in our firestore
    await Firestore.instance.collection('photos').add(photo.toJson());

    setState(() {
      _uploading = false;
    });

    // Dismiss this widget
    Navigator.pop(context);
  }

  Widget _buildPhotoBox() {
    return new DecoratedBox(
      decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
      child: new SizedBox(
        width: 100.0,
        height: 100.0,
        child: _photo != null
            ? new Center(child: new Image.file(_photo))
            : new IconButton(
                color: Theme.of(context).accentColor,
                onPressed: _onChooseImage,
                icon: new Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildTitleField() {
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: new TextField(
          decoration: new InputDecoration(labelText: '*Title'),
          onChanged: (value) {
            setState(() {
              _title = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return new Expanded(
      child: new TextField(
        decoration: new InputDecoration(labelText: 'Description'),
        maxLength: 150,
        maxLines: 5,
        onChanged: (value) {
          setState(() {
            _description = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Upload A Photo'),
        actions: _photo != null && _title != null
            ? <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                  ),
                  onPressed: _uploadPhoto,
                )
              ]
            : null,
      ),
      body: _uploading
          ? new Center(child: new CircularProgressIndicator())
          : new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      _buildPhotoBox(),
                      _buildTitleField(),
                    ],
                  ),
                  _buildDescriptionField()
                ],
              ),
            ),
    );
  }
}
