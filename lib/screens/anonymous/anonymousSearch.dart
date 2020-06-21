import 'package:Wiggle2/screens/wrapper/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/screens/anonymous/anonothersProfile.dart';
import 'package:Wiggle2/screens/home/othersProfile.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/home/conversationScreen.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../authenticate/helper.dart';
import 'anonymousConversation.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/screens/home/home.dart';

class AnonymousSearch extends StatefulWidget {
  List<Wiggle> wiggles;

  AnonymousSearch({this.wiggles});

  @override
  _AnonymousSearchState createState() => _AnonymousSearchState();
}

class _AnonymousSearchState extends State<AnonymousSearch> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;
  Stream chatsScreenStream;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .getUserByUsername(searchTextEditingController.text)
          .then((val) {
        searchSnapshot = val;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  getChatRoomID(String a, String b) {
    codeUnit(String a) {
      int count = 0;
      for (int i = 0; i < a.length; i++) {
        count += a.codeUnitAt(i);
      }
      return count;
    }

    if (a.length < b.length) {
      return "$a\_$b";
    } else if (a.length > b.length) {
      return "$b\_$a";
    } else {
      print(codeUnit(a) + codeUnit(b));
      return (codeUnit(a) + codeUnit(b)).toString();
    }
  }

  createChatRoomAndStartConversation(UserData userData, Wiggle wiggle) {
    String chatRoomID = getChatRoomID(userData.email, wiggle.nickname);
    List<String> users = [userData.email, wiggle.email];

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomID
    };
    DatabaseService().uploadBondData(
        userData: userData,
        myAnon: true,
        wiggle: wiggle,
        friendAnon: false,
        chatRoomID: chatRoomID);
    DatabaseService().createAnonymousChatRoom(chatRoomID, chatRoomMap);
    Navigator.of(context).pushAndRemoveUntil(
      FadeRoute(
        page: AnonymousConversation(
          friendAnon: false,
          wiggles: widget.wiggles,
          wiggle: wiggle,
          chatRoomId: chatRoomID,
          userData: userData,
        ),
      ),
      ModalRoute.withName('AnonymousConversation'),
    );
  }

  Widget searchTile({String myEmail, Wiggle wiggle, UserData userData}) {
    if (wiggle.email != userData.email) {
      return RaisedButton(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            FadeRoute(
              page: OthersProfile(
                wiggles: widget.wiggles,
                wiggle: wiggle,
                userData: userData,
              ),
            ),
            ModalRoute.withName('OthersProfile'),
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: Color(0xFF555555),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: ClipOval(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Image.network(
                            wiggle.dp,
                            fit: BoxFit.fill,
                          ) ??
                          Image.asset('assets/images/profile1.png',
                              fit: BoxFit.fill),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  wiggle.name,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createChatRoomAndStartConversation(userData, wiggle);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Text('Text'),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget searchList(List<Wiggle> wiggles) {
    String name;
    Wiggle currentwiggle;

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if (userData != null) {
            return searchSnapshot != null
                ? ListView.builder(
                    itemCount: searchSnapshot.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      name = searchSnapshot.documents[index].data['name'];
                      for (int i = 0; i < wiggles.length; i++) {
                        if (wiggles[i].name == name) {
                          currentwiggle = wiggles[i];
                        }
                      }
                      return searchTile(
                          myEmail: userData.email,
                          wiggle: currentwiggle,
                          userData: userData);
                    })
                : Container();
          } else {
            return Loading();
          }
        });
  }

  getUserInfo() async {
    Constants.myEmail = await Helper.getUserEmailSharedPreference();
    Constants.myName = await Helper.getUserNameSharedPreference();
    // print(Constants.myName);
    DatabaseService().getAnonymousChatRooms(Constants.myEmail).then((val) {
      setState(() {
        chatsScreenStream = val;
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(LineAwesomeIcons.home),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    FadeRoute(page: Wrapper()), ModalRoute.withName('Wrapper'));
              }),
          centerTitle: true,
          title: Text("S E A R C H",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100)),
        ),
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Color(0xFF373737),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: searchTextEditingController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "search username...",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                initiateSearch();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                    "assets/images/search_white.png"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      searchList(widget.wiggles),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
