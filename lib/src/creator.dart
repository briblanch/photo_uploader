import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as io;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:meme_generator/src/model.dart';

// Copies an image, scaled via nearest-neighbor.
// Thanks to Greg Littlefield for the assist on this handy function :)
io.Image copyScale(io.Image src, int w, int h) {
  var xRatio = src.width / w;
  var yRatio = src.height / h;
  io.Image dst = new io.Image(w, h, src.format);
  for (int yi = 0; yi < h; ++yi) {
    for (int xi = 0; xi < w; ++xi) {
      dst.setPixel(
          xi, yi, src.getPixel((xi * xRatio).floor(), (yi * yRatio).floor()));
    }
  }
  return dst;
}

class Creator extends StatefulWidget {
  @override
  _CreatorState createState() => new _CreatorState();
}

class _CreatorState extends State<Creator> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  io.Image _originalImage;
  io.Image _memedImage;
  String _memeString;
  bool uploading = false;

  Future _onPickImage() async {
    final pickedImage = await ImagePicker.pickImage();

    pickedImage.readAsBytes().then((bytes) {
      setState(() {
        _originalImage = io.decodeJpg(bytes);
      });
    });
  }

  Future _onImageUpload() async {
    setState(() {
      uploading = true;
    });

    final uuid = new Uuid().v4();
    final file = new File('${(await getTemporaryDirectory()).path}/$uuid.jpg')
      ..writeAsBytesSync(io.encodeJpg(_memedImage));

    final task = FirebaseStorage.instance.ref().child('memes/$uuid').put(file);

    final downloadUrl = (await task.future).downloadUrl;
    final meme = new Meme(downloadUrl.toString(), new DateTime.now());
    await Firestore.instance.collection('memes').add(meme.toJson());

    await file.delete();

    setState(() {
      uploading = false;
      _originalImage = null;
    });

    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text('Meme successfully upload'),
      ),
    );
  }

  void _onTextEnter(String newValue) {
    setState(() {
      _memeString = newValue;

      _memedImage = io.drawString(
        io.copyCrop(_originalImage, 0, 0, 500, 500),
        io.arial_48,
        50,
        50,
        _memeString,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Create a meme'),
        actions: _originalImage != null
            ? <Widget>[
                new IconButton(
                  icon: new Icon(Icons.cloud_upload),
                  onPressed: _onImageUpload,
                )
              ]
            : <Widget>[],
      ),
      body: uploading
          ? new Center(child: new CircularProgressIndicator())
          : _originalImage == null
              ? new Center(
                  child: new RaisedButton(
                    child: new Text('Pick an image'),
                    onPressed: _onPickImage,
                  ),
                )
              : new Stack(
                  children: <Widget>[
                    new SizedBox.fromSize(
                      size: new Size(0.0, 0.0),
                      child: new TextField(
                        autofocus: true,
                        onChanged: _onTextEnter,
                        maxLines: 4,
                      ),
                    ),
                    new SizedBox.expand(
                      child: new Image.memory(
                        io.encodeJpg(_memedImage ?? _originalImage),
                      ),
                    )
                  ],
                ),
    );
  }
}
