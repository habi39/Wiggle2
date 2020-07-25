import 'package:Wiggle2/screens/authenticate/intro/introPage1.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/services/database.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../models/user.dart';
import '../../../models/wiggle.dart';
import 'package:Wiggle2/shared/constants.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:Wiggle2/models/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Filterpage extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;
  Filterpage({this.userData, this.wiggles});
  @override
  _FilterpageState createState() => _FilterpageState();
}

class _FilterpageState extends State<Filterpage> {
  var isMaleSelected = true;
  var isFemaleSelected = false;
  var noresults = false;
  List<Wiggle> filtered = [];
  List<Wiggle> toremove = [];
  List<String> _courses = <String>[
    'Any Course',
    'Computer Science',
    'Business Analytics',
    'Business',
    'Arts and Social Sciences',
    'Mechanical Engineering'
  ];
  String selectedcourse, selectedgender;
  @override
  void initState() {
    widget.wiggles.forEach((element) {
      if (element.gender == 'Male' && !filtered.contains(element)) {
        filtered.add(element);
      } else if (element.gender == 'Female') {
        filtered.remove(element);
      }
    });
    filtered.forEach((element) {
      print(element.name);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.95,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              left: 30,
              right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I would want my friend to be...",
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        setState(() {
                          isMaleSelected = true;
                          isFemaleSelected = false;
                          selectedgender = "Male";
                        });
                        // widget.wiggles.forEach((element) {
                        //   if (element.gender == 'Male' &&
                        //       !filtered.contains(element)) {
                        //     filtered.add(element);
                        //   } else if (element.gender == 'Female') {
                        //     filtered.remove(element);
                        //   }

                        //   ;
                        // });

                        // filtered.forEach((element) {
                        //   print(element.name);
                        // });
                      },
                      child: ChoiceChip(
                          LineAwesomeIcons.male, 'Male', isMaleSelected)),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isMaleSelected = false;
                          isFemaleSelected = true;
                          selectedgender = "Female";
                        });

                        // widget.wiggles.forEach((element) {
                        //   if (element.gender == 'Female' &&
                        //       !filtered.contains(element)) {
                        //     filtered.add(element);
                        //   } else if (element.gender == 'Male') {
                        //     filtered.remove(element);
                        //   }
                        //   ;
                        // });

                        // filtered.forEach((element) {
                        //   print(element.name);
                        // });
                      },
                      child: ChoiceChip(
                          LineAwesomeIcons.female, 'Female', isFemaleSelected)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
                    items: _courses
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.amber),
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (selectcourse) {
                      setState(() {
                        selectedcourse = selectcourse;
                      });
                      //   if (selectedcourse != 'Any Course') {
                      //   filtered.forEach((element) {
                      //     if (element.course != selectedcourse) {
                      //       toremove.add(element);
                      //     }
                      //   });
                      //   filtered
                      //       .removeWhere((element) => toremove.contains(element));
                      // }
                    },
                    isExpanded: false,
                    decoration: textFieldInputDecoration('Course'),
                  )),
                ],
              ),
              FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  if (selectedcourse != 'Any Course' &&
                      selectedcourse != null) {
                    widget.wiggles.forEach((element) {
                      if (element.gender == selectedgender &&
                          element.course == selectedcourse &&
                          !filtered.contains(element)) {
                        filtered.add(element);
                      } else if (element.gender != selectedgender ||
                          element.course != selectedcourse) {
                        filtered.remove(element);
                      }
                      ;
                    });
                  } else {
                    widget.wiggles.forEach((element) {
                      if (element.gender == selectedgender &&
                          !filtered.contains(element)) {
                        filtered.add(element);
                      } else if (element.gender != selectedgender) {
                        filtered.remove(element);
                      }
                      ;
                    });
                  }

                  if (filtered.isEmpty) {
                    setState(() {
                      noresults = true;
                    });
                    print('empty');
                  } else {
                    filtered.forEach((element) {
                      print(element.name);
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => IntroPage1(
                            userData: widget.userData, wiggles: filtered),
                      ),
                    );
                  }
                },
              ),
              noresults
                  ? Container(
                      child: Text(
                        'No one is found, try other options',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w200),
                      ),
                    )
                  : Container()
            ],
          ),
        )
      ],
    ));
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChip(this.icon, this.text, this.isSelected);
  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(25.0)))
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 25,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Text(widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w100))
        ],
      ),
    );
  }
}
