import 'dart:io';

import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

class UploadImage extends StatefulWidget {
  final UserData userData;
  UploadImage({this.userData});

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage>
    with AutomaticKeepAliveClientMixin<UploadImage> {
  File file;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  bool uploading = false;
  final StorageReference storageReference =
      FirebaseStorage.instance.ref().child("Post Pictures");
  final postReference = Firestore.instance.collection("posts");
  String postId = Uuid().v4();

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = imageFile;
    });
  }

  removeImage() {
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  compressPhoto() async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImage = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(
        ImD.encodeJpg(mImageFile, quality: 60),
      );
    setState(() {
      file = compressedImage;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressPhoto();

    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFirestore(downloadUrl, descriptionTextEditingController.text);

    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  savePostInfoToFirestore(String url, String description) {
    postReference.document(postId).setData({
      "postId": postId,
      "name": widget.userData.name,
      "timestamp": Timestamp.now(),
      "email": widget.userData.email,
      "description": description,
      "likes": {},
      "url": url
    });
  }

  linearProgress() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.redAccent),
      ),
    );
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: removeImage,
        // ),
        title: Text(
          "New Post",
          style: TextStyle(
              color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          uploading ? LinearProgressIndicator() : Text(''),
          FlatButton(
            onPressed: uploading ? null : () => controlUploadAndSave(),
            child: Text(
              "Share",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(file), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 27,
              child: ClipOval(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Image.network(
                    widget.userData.dp,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Container(
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: descriptionTextEditingController,
                decoration:
                    textFieldInputDecoration(' Say something about your image'),
                // decoration: InputDecoration(
                //   hintText: 'Say something about your image',
                //   hintStyle: TextStyle(color: Colors.grey),
                //   border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  takeImage(nContext) {
    return showDialog(
        context: nContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("New Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  "Capture Image with Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  displayUploadScreen() {
    return Container(
        color: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_photo_alternate, color: Colors.red, size: 200),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => takeImage(context),
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.grey,
      //   title: Text(
      //     "Upload Image",
      //     textAlign: TextAlign.right,
      //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: file == null ? displayUploadScreen() : displayUploadFormScreen(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
