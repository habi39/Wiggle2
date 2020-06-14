import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:Wiggle2/screens/home/othersProfile.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/screens/home/conversationScreen.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/shared/loading.dart';
import '../authenticate/helper.dart';

class SearchScreen extends StatefulWidget {
  List<Wiggle> wiggles;

  SearchScreen({this.wiggles});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    print(a);
    print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomAndStartConversation(UserData userData, Wiggle wiggle) {
    String chatRoomID = getChatRoomID(userData.email, wiggle.email);
    List<String> users = [userData.email, wiggle.email];

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomID
    };
    DatabaseService().createChatRoom(chatRoomID, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          wiggles: widget.wiggles,
          wiggle: wiggle,
          chatRoomId: chatRoomID,
          userData: userData,
        ),
      ),
    );
  }

  Widget searchTile({String myEmail, Wiggle wiggle, UserData userData}) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OthersProfile(
              wiggles: widget.wiggles,
              wiggle: wiggle,
              userData: userData,
            ),
          ),
        );
      },
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.blue,
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
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Text('Text'),
            ),
          ),
        ],
      ),
    );
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
    DatabaseService().getChatRooms(Constants.myEmail).then((val) {
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
          backgroundColor: Colors.blue[900],
          title: Text("Search",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.blueGrey,
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
                              child:
                                  Image.asset("assets/images/search_white.png"),
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
    );
  }
}
