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

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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

      dynamic result = DatabaseService(uid: user.uid).updateUserData(email,
          name,  selectedGenderType, selectedBlockType, bio, x, false,media,playlist,selectedcourse,home);
    }

    if (_image != null) {
      uploadPic();
      setState(() {
        loading = false;
      });
    } else {
      print(y);
      dynamic result = DatabaseService(uid: user.uid).updateUserData(email,
          name,  selectedGenderType, selectedBlockType, bio, y, false,media,playlist,selectedcourse,home);
      DatabaseService(uid: user.uid).uploadWhoData(
          email: email,
          name: name,
          dp: y,
          gender: selectedGenderType,
          score: 0);
      setState(() {
        loading = false;
      });
    }
    Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));

    Helper.saveUserEmailSharedPreference(email);
    Helper.saveUserNameSharedPreference(name);

    Helper.saveUserLoggedInSharedPreference(true);
  }

  String email = '';
  String error = '';
  String name = '';
  String bio = '';
  String selectedGenderType,selectedcourse,home;
  String selectedBlockType;
  List<String> _courses = <String>['Computer Science', 'Business Analytics','Business','Arts and Social Sciences','Mechanical Engineering'];
  List<String> _homeArea = <String>['Woodlands','Serangoon','Yishun','Sambawang','Clementi','Bishan','Ang Mo Kio'];
  String media;
  String playlist;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(LineAwesomeIcons.home),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(page: Wrapper()),
                          ModalRoute.withName('Wrapper'));
                    }),
                title: Text("E D I T   P R O F I L E",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                          : Image.network(
                                                              userData.dp,
                                                              fit: BoxFit.fill,
                                                            ),
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
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.face,
                                                color: Colors.amber,
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: userData.name,
                                                  validator: (val) {
                                                    return val.isEmpty
                                                        ? 'Please provide your name'
                                                        : null;
                                                  },
                                                  onChanged: (val) {
                                                    setState(() => name = val);
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                  decoration:
                                                      textFieldInputDecoration(
                                                          ' Name'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
                                         value: userData.gender,
                                          validator: (val) {
                                            return val.isEmpty
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
                                              selectedGenderType =
                                                  selectedGender;
                                            });
                                          },
                                          isExpanded: false,
                                          hint: Text(
                                            'Choose Gender',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                        Icon(
                                          FontAwesomeIcons.home,
                                          size: 25.0,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 20.0),
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            value: userData.block,
                                            validator: (val) {
                                              return val.isEmpty
                                                  ? 'Please provide a valid Block'
                                                  : null;
                                            },
                                            items: _blockType
                                                .map((value) =>
                                                    DropdownMenuItem(
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
                                                selectedBlockType =
                                                    selectedBlock;
                                              });
                                            },
                                            isExpanded: false,
                                            hint: Text(
                                              'Choose Block',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                          child: TextFormField(
                                              // maxLines: 3,
                                              initialValue: userData.bio,
                                              onChanged: (val) {
                                                setState(() => bio = val);
                                              },
                                              style:
                                                  TextStyle(color: Colors.amber),
                                              decoration:
                                                  textFieldInputDecoration(
                                                      ' Bio')),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                
                                Row(
                                  children: <Widget>[
                                    
                                    Icon(
                                      FontAwesomeIcons.book,
                                      size: 25.0,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 20.0),
                                    Expanded(
                                        child: DropdownButtonFormField(
                                         value: userData.course==""? null:userData.course,
                                          
                                      validator: (val) {
                                        return val == null
                                            ? 'Please provide a valid Course'
                                            : null;
                                      },
                                      items: _courses
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (selectecourse) {
                                        setState(() {
                                          selectedcourse = selectecourse;
                                        });
                                      },
                                      
                                      isExpanded: false,
                                      decoration: textFieldInputDecoration('Choose Course'),
                                     
                                    )),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.laptop,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                                      userData.media,
                                          validator: (val) {
                                            return val.isEmpty
                                                ? 'Please provide your social media handles'
                                                : null;
                                          },
                                          onChanged: (val) {
                                            setState(() => media = val);
                                          },
                                          style: TextStyle(color: Colors.amber),
                                          decoration: textFieldInputDecoration(
                                              '  Instagram Handle')),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.music,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue:
                                                      userData.playlist,
                                          validator: (val) {
                                            return val.isEmpty
                                                ? 'Please provide your favourite artist'
                                                : null;
                                          },
                                          onChanged: (val) {
                                            setState(() => playlist = val);
                                          },
                                          style: TextStyle(color: Colors.amber),
                                          decoration: textFieldInputDecoration(
                                              '  Favourite Artist')),
                                    ),
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
                                    SizedBox(width: 20.0),
                                    Expanded(
                                        child: DropdownButtonFormField(
                                          value: userData.accoms ==""? null:userData.accoms ,
                                      validator: (val) {
                                        return val == null
                                            ? 'Please provide a valid Course'
                                            : null;
                                      },
                                      items: _homeArea
                                          .map((value) => DropdownMenuItem(
                                            
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                ),
                                               value: value
                                              ))
                                          .toList(),
                                      onChanged: (selectedhome) {
                                        setState(() {
                                          home = selectedhome;
                                        });
                                      },
                                       
                                      isExpanded: false,
                                      decoration: textFieldInputDecoration('I Stay Around...'),
                                     
                                    )),
                                  ],
                                ),
                                    SizedBox(height: 18),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          if (email == '') {
                                            email = userData.email;
                                          }
                                          if (name == '') {
                                            name = userData.name;
                                          }
                                          if (bio == '') {
                                            bio = userData.bio;
                                          }
                                          if (selectedGenderType == null) {
                                            selectedGenderType =
                                                userData.gender;
                                          }
                                          if (selectedBlockType == null) {
                                            selectedBlockType = userData.block;
                                          }
                                          if (_image == null) {
                                            y = userData.dp;
                                          }
                                          if (media == null){
                                            media =userData.media;
                                          }
                                          if (playlist == null){
                                            playlist = userData.playlist;
                                          }
                                          if (selectedcourse == null){
                                            selectedcourse = userData.course;
                                          }
                                          if (home ==null){
                                            home = userData.accoms;
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
