import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';

import 'comments.dart';
import 'createPage.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  Stream blogsStream;

  Widget BlogsList(UserData userData) {
    return StreamBuilder(
        stream: blogsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BlogsTile(
                    userData: userData,
                    authorName:
                        snapshot.data.documents[index].data['authorName'],
                    title: snapshot.data.documents[index].data["title"],
                    description: snapshot.data.documents[index].data['desc'],
                    imgUrl: snapshot.data.documents[index].data['imgUrl'],
                  );
                });
          } else {
            return Loading();
          }
        });
  }

  @override
  void initState() {
    DatabaseService().getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context) ?? User();
    // final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          if (userData != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "F O R U M",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
                ),
                actions: <Widget>[
                  IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreatePage(userData: userData),
                          ),
                        );
                      }),
                ],
                // backgroundColor: Colors.transparent,
              ),
              body: BlogsList(userData),
              // floatingActionButton: Container(
              //   // padding: EdgeInsets.symmetric(vertical: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: <Widget>[
              //       FloatingActionButton(
              //         onPressed: () {
              //           Navigator.push(context,
              //               MaterialPageRoute(builder: (context) => CreatePage()));
              //         },
              //         child: Icon(Icons.add),
              //       )
              //     ],
              //   ),
              // ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  UserData userData;
  BlogsTile(
      {this.imgUrl,
      this.title,
      this.description,
      this.authorName,
      this.userData});

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width,
      menuBoxDecoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          FadeRoute(
            page: Comments(
                userData: userData,
                authorName: authorName,
                description: description,
                title: title),
          ),
          ModalRoute.withName('Comments'),
        );
      },
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text(
              "Delete Post",
              style: TextStyle(color: Colors.black),
            ),
            trailingIcon: Icon(Icons.delete),
            onPressed: () {
              // DatabaseService()
              //     .blogReference
              //     .document(description)
              //     .collection('chats')
              //     .getDocuments()
              //     .then((doc) {
              //   if (doc.documents[0].exists) {
              //     doc.documents[0].reference.delete();
              //   }
              // });

              DatabaseService()
                  .blogReference
                  .document(description)
                  .get()
                  .then((doc) {
                if (doc.exists) {
                  doc.reference.delete();
                }
              });
            },
            backgroundColor: Colors.redAccent)
      ],
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          FadeRoute(
            page: Comments(
                userData: userData,
                authorName: authorName,
                description: description,
                title: title),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          height: 150,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imgUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      description,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(authorName)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
