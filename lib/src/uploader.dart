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
  _PhotoUploaderState createState() => _PhotoUploaderState();
}

class _PhotoUploaderState extends State<PhotoUploader> {
  bool _uploading = false;
  File _photo;
  String _title;
  String _description;

  Future<void> _onChooseImage() async {
    final pickedImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );

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
        .child('photos/${Uuid().v4()}.jpg')
        .putFile(_photo);

    // Wait for the upload to finish and retrieve the download url
    final downloadUrl = (await task.future).downloadUrl;

    final photo = Photo(
      downloadUrl.toString(),
      _title,
      _description,
      DateTime.now().toUtc(),
    );

    // Upload our photo to the photos ref in our firestore
    await Firestore.instance.collection('photos').add(photo.toJson());

    setState(() {
      _uploading = false;
    });

    // Dismiss this widget
    Navigator.pop(context, true);
  }

  Widget _buildPhotoBox() {
    return Container(
      width: 75.0,
      height: 75.0,
      child: _photo != null
          ? CircleAvatar(
              backgroundImage: FileImage(_photo),
            )
          : Material(
              color: Theme.of(context).accentColor,
              shape: CircleBorder(),
              child: IconButton(
                color: Colors.white,
                onPressed: _onChooseImage,
                icon: Icon(
                  Icons.add_a_photo,
                ),
              ),
            ),
    );
  }

  Widget _buildTitleField() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: TextField(
          decoration: InputDecoration(labelText: '*Title'),
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
    return TextField(
      decoration: InputDecoration(labelText: 'Description'),
      maxLength: 150,
      maxLines: 5,
      onChanged: (value) {
        setState(() {
          _description = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload A Photo'),
        actions: _photo != null && _title != null
            ? <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                  ),
                  onPressed: _uploadPhoto,
                )
              ]
            : null,
      ),
      body: _uploading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Row(
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
