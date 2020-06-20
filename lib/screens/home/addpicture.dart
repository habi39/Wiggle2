import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Wiggle2/screens/home/profile.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';
import '../../services/database.dart';
import 'package:Wiggle2/shared/constants.dart';

class Addpicture extends StatefulWidget {
  @override
  _AddpictureState createState() => _AddpictureState();
}

class _AddpictureState extends State<Addpicture> {
  File _image;
  String x;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 50,
              leading: IconButton(
                  icon: Icon(LineAwesomeIcons.home),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        FadeRoute(page: Wrapper()),
                        ModalRoute.withName('Wrapper'));
                  }),
            ),
            body: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
                      child: (_image != null)
                          ? Image.file(
                              _image,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              color: Colors.white70,
                            ),
                    ),
                  ],
                ),
                IconButton(
                  color: Colors.cyan,
                  icon: Icon(Icons.camera_alt, size: 30),
                  onPressed: () {
                    getImage();
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    StorageReference firebaseStorageReference =
                        FirebaseStorage.instance.ref().child(_image.path);

                    StorageUploadTask uploadTask =
                        firebaseStorageReference.putFile(_image);
                    StorageTaskSnapshot taskSnapshot =
                        await uploadTask.onComplete;
                    x = (await taskSnapshot.ref.getDownloadURL()).toString();

                    dynamic result =
                        DatabaseService(uid: user.uid).uploadPhotos(x);

                    if (result != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(page: Wrapper()),
                          ModalRoute.withName('Wrapper'));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blueGrey),
                    child: Text('Confirm', style: simpleTextStyle()),
                  ),
                ),
              ],
            ),
          );
  }
}
