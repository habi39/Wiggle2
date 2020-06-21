import 'package:Wiggle2/games/smashbros/main.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:Wiggle2/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comments.dart';
import 'createPage.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  Stream blogsStream;

  Widget BlogsList() {
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
    final wiggles = Provider.of<List<Wiggle>>(context) ?? [];
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
              body: BlogsList(),
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
  BlogsTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.description,
      @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        FadeRoute(
          page: Comments(
              authorName: authorName, description: description, title: title),
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
                // fit: BoxFit.cover,
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
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
    );
  }
}
