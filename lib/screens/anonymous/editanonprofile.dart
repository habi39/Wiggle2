import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/authenticate/helper.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../services/database.dart';


class EditAnonProfile extends StatefulWidget {
  @override
  _EditAnonProfileState createState() => _EditAnonProfileState();
}

class _EditAnonProfileState extends State<EditAnonProfile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  File _image;
  String y;
  String x;
  List<String> _genderType = <String>[
    'Male',
    'Female',
  ];
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  List<String> _blockType = <String>['A', 'B', 'C', 'D', 'E'];

  updateUser(BuildContext context) {
    final user = Provider.of<User>(context);

    Future uploadPic() async {
      StorageReference firebaseStorageReference =
          FirebaseStorage.instance.ref().child(_image.path);

      StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      x = (await taskSnapshot.ref.getDownloadURL()).toString();

      dynamic result = DatabaseService(uid: user.uid)
          .updateAnonData(anonBio, anonInterest, x,nickname);
    }

    if (_image != null) {
      uploadPic();
      setState(() {
        loading = false;
      });
    } else {
      print(y);
      dynamic result = DatabaseService(uid: user.uid)
          .updateAnonData(anonBio, anonInterest, y,nickname);
    }
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));

    Helper.saveUserLoggedInSharedPreference(true);
  }

  String anonInterest = '';
  String anonBio = '';
  String nickname = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                    icon: Icon(LineAwesomeIcons.home),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(page: Wrapper()),
                          ModalRoute.withName('Wrapper'));
                    }),
              ),
              body: StreamBuilder<UserData>(
                  stream: DatabaseService(uid: user.uid).userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserData userData = snapshot.data;
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Scaffold(
                          body: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height - 50,
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(width: 50),
                                              Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 60,
                                                  child: ClipOval(
                                                    child: new SizedBox(
                                                      width: 180,
                                                      height: 180,
                                                      child: (_image != null)
                                                          ? Image.file(
                                                              _image,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : userData.anonDp !=
                                                                  ""
                                                              ? Image.network(
                                                                  userData
                                                                      .anonDp,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/profile1.png',
                                                                  fit: BoxFit
                                                                      .cover),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 60),
                                                child: IconButton(
                                                  color: Colors.amber,
                                                  icon: Icon(Icons.camera_alt,
                                                      size: 30),
                                                  onPressed: () {
                                                    getImage();
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(children: <Widget>[
                                            CircleAvatar(
                                              backgroundColor: Colors.amber,
                                              radius: 12.5,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/images/ghosty2.png',
                                                  fit: BoxFit.fill,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: TextFormField(
                                                  initialValue:
                                                      userData.nickname,
                                                  validator: (val) {
                                                    return val.isEmpty
                                                        ? 'Please provide a nickname'
                                                        : null;
                                                  },
                                                  onChanged: (val) {
                                                    setState(
                                                        () => nickname = val);
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                  decoration:
                                                      textFieldInputDecoration(
                                                          ' Nickname to be used when anonymous')),
                                            ),
                                          ]),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.face,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: TextFormField(
                                                    initialValue:
                                                        userData.anonBio,
                                                    validator: (val) {
                                                      return val.isEmpty
                                                          ? 'Please provide something about you'
                                                          : null;
                                                    },
                                                    onChanged: (val) {
                                                      setState(
                                                          () => anonBio = val);
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.amber),
                                                    decoration:
                                                        textFieldInputDecoration(
                                                            'About Me')),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 24),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: TextFormField(
                                                    initialValue:
                                                        userData.anonInterest,
                                                    validator: (val) {
                                                      return val.isEmpty
                                                          ? 'Please provide your interest'
                                                          : null;
                                                    },
                                                    onChanged: (val) {
                                                      setState(() =>
                                                          anonInterest = val);
                                                    },
                                                    style: TextStyle(
                                                        color: Colors.amber),
                                                    decoration:
                                                        textFieldInputDecoration(
                                                            'Interesting Facts')),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 18),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });

                                          if (anonInterest == '') {
                                            anonInterest =
                                                userData.anonInterest;
                                          }

                                          if (anonBio == '') {
                                            anonBio = userData.anonBio;
                                          }

                                          if (nickname == '') {
                                            nickname = userData.nickname;
                                          }

                                          if (_image == null) {
                                            y = userData.anonDp;
                                          }
                                          dynamic result =
                                              await updateUser(context);
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Color(0xFF373737)),
                                        child: Text('Confirm',
                                            style: simpleTextStyle()),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  }),
            ),
          );
  }
}
