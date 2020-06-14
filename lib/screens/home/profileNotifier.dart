import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:Wiggle2/models/user.dart';

class ProfileNotifier with ChangeNotifier {
  List<UserData> _profileList = [];
  UserData _currentProfile;

  UnmodifiableListView<UserData> get profileList =>
      UnmodifiableListView(_profileList);

  UserData get currentProfile => _currentProfile;

  set profileList(List<UserData> profileList) {
    _profileList = profileList;
    notifyListeners();
  }

  set currentProfile(UserData profile) {
    _currentProfile = profile;
    notifyListeners();
  }
}
