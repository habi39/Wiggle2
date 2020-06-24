import 'dart:io';

import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreatePage extends StatefulWidget {
  final UserData userData;

  CreatePage({this.userData});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String authorName, title, desc;

  File selectedImage;
  bool _isLoading = false;

  // Future getImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     selectedImage = image;
  //   });
  // }
  pickImageFromGallery(context) async {
    Navigator.pop(context);
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = _image;
    });
  }

  captureImageWithCamera(context) async {
    Navigator.pop(context);
    var _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    setState(() {
      selectedImage = _image;
    });
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
                onPressed: () => captureImageWithCamera(nContext),
              ),
              SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => pickImageFromGallery(nContext),
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

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      /// uploading image to firebase storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is url $downloadUrl");

      if (desc.isNotEmpty) {
        Map<String, dynamic> messageMap = {
          "message": desc,
          "author": widget.userData.nickname,
          "time": Timestamp.now(),
        };
        DatabaseService().addForumMessages(desc, messageMap);
      }

      Map<String, dynamic> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": widget.userData.nickname,
        "title": title,
        "desc": desc,
        "time": Timestamp.now(),
      };
      DatabaseService().addData(blogMap, desc).then((result) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
          ),
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.file_upload)),
            )
          ],
        ),
        body: _isLoading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            takeImage(context);
                          },
                          child: selectedImage != null
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  // height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      selectedImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  height: 170,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black45,
                                  ),
                                )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: <Widget>[
                            // TextField(
                            //   decoration: InputDecoration(hintText: "Author Name"),
                            //   onChanged: (val) {
                            //     authorName = val;
                            //   },
                            // ),
                            TextField(
                              decoration: InputDecoration(hintText: "Title"),
                              onChanged: (val) {
                                title = val;
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(hintText: "Desc"),
                              onChanged: (val) {
                                desc = val;
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
