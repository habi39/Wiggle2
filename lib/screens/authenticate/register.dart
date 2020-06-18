import 'package:flutter/material.dart';
import 'package:Wiggle2/services/auth.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  bool loading = false;
  var selectedGenderType, selectedBlockType;
  File _image;
  var x;
  List<String> _genderType = <String>[
    'Male',
    'Female',
  ];
  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  List<String> _blockType = <String>['A', 'B', 'C', 'D', 'E'];

  signMeUp(BuildContext context) {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      Helper.saveUserEmailSharedPreference(email);
      Helper.saveUserNameSharedPreference(name);
      Helper.saveUserLoggedInSharedPreference(true);

      Future uploadPic() async {
        StorageReference firebaseStorageReference =
            FirebaseStorage.instance.ref().child(_image.path);

        StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        x = (await taskSnapshot.ref.getDownloadURL()).toString();

        await _auth.registerWithEmailAndPassword(email, password, name,
            nickname, selectedGenderType, selectedBlockType, bio, x, false);
      }

      if (_image != null) {
        uploadPic().then((value) => setState(() {
              loading = false;
            }));
      } else {
        _auth
            .registerWithEmailAndPassword(
                email,
                password,
                name,
                nickname,
                selectedGenderType,
                selectedBlockType,
                bio,
                'https://firebasestorage.googleapis.com/v0/b/wiggle2-1d590.appspot.com/o/data%2Fuser%2F0%2Fcom.example.Wiggle2%2Fcache%2Fimage_picker8049276365349124154.png?alt=media&token=e2066efa-287f-45e9-9df6-6604a1838567',
                false)
            .then((value) => setState(() {
                  loading = false;
                }));
      }
    }
  }

  String email = '';
  String password = '';
  String error = '';
  String name = '';
  String bio = '';
  String nickname = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 3),
                              Row(children: <Widget>[
                                Icon(
                                  Icons.alternate_email,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: TextFormField(
                                      validator: (val) {
                                        return RegExp(
                                                    r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
                                                .hasMatch(val)
                                            ? null
                                            : "Please provide a valid Email";
                                      },
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      style: TextStyle(color: Colors.amber),
                                      decoration:
                                          textFieldInputDecoration(' Email')),
                                ),
                              ]),
                              Row(children: <Widget>[
                                Icon(
                                  Icons.lock,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 3),
                                Expanded(
                                  child: TextFormField(
                                      obscureText: true,
                                      validator: (val) {
                                        return val.isEmpty || val.length <= 6
                                            ? 'Please provide a valid password'
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      style: TextStyle(color: Colors.amber),
                                      decoration: textFieldInputDecoration(
                                          ' Password')),
                                ),
                              ]),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                              : Image.asset(
                                                  'assets/images/profile1.png',
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: IconButton(
                                      color: Colors.amber,
                                      icon: Icon(Icons.camera_alt, size: 30),
                                      onPressed: () {
                                        getImage();
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.face,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextFormField(
                                        validator: (val) {
                                          return val.isEmpty
                                              ? 'Please provide your name'
                                              : null;
                                        },
                                        onChanged: (val) {
                                          setState(() => name = val);
                                        },
                                        style: TextStyle(color: Colors.amber),
                                        decoration:
                                            textFieldInputDecoration(' Name')),
                                  ),
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
                                      validator: (val) {
                                        return val.isEmpty
                                            ? 'Please provide a nickname'
                                            : null;
                                      },
                                      onChanged: (val) {
                                        setState(() => nickname = val);
                                      },
                                      style: TextStyle(color: Colors.amber),
                                      decoration: textFieldInputDecoration(
                                          ' Nickname to be used when anonymous')),
                                ),
                              ]),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.male,
                                    size: 25.0,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.female,
                                    size: 25.0,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 20.0),
                                  Expanded(
                                      child: DropdownButtonFormField(
                                    validator: (val) {
                                      return val == null
                                          ? 'Please provide a valid Gender'
                                          : null;
                                    },
                                    items: _genderType
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: Colors.amber),
                                              ),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (selectedGender) {
                                      setState(() {
                                        selectedGenderType = selectedGender;
                                      });
                                    },
                                    value: selectedGenderType,
                                    isExpanded: false,
                                    hint: Text(
                                      'Choose Gender',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.home,
                                    size: 25.0,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 45.0),
                                  Expanded(
                                    child: DropdownButtonFormField(
                                      validator: (val) {
                                        return val == null
                                            ? 'Please provide a valid Block'
                                            : null;
                                      },
                                      items: _blockType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (selectedBlock) {
                                        setState(() {
                                          selectedBlockType = selectedBlock;
                                        });
                                      },
                                      value: selectedBlockType,
                                      isExpanded: false,
                                      hint: Text(
                                        'Choose Block',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 3),
                                  Expanded(
                                    child: TextField(
                                        onChanged: (val) {
                                          setState(() => bio = val);
                                        },
                                        style: TextStyle(color: Colors.amber),
                                        decoration:
                                            textFieldInputDecoration(' Bio')),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18),
                              GestureDetector(
                                onTap: () {
                                  signMeUp(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.blueGrey),
                                  child: Text('Create Account',
                                      style: simpleTextStyle()),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account? ",
                                      style: simpleTextStyle()),
                                  GestureDetector(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8),
                                      child: Text("Sign In",
                                          style: TextStyle(
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.underline)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
