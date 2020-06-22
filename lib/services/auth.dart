import 'package:firebase_auth/firebase_auth.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/services/database.dart';

import 'database.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // creates a firebase instance to be used ie creating an anonymous user

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //get the user
  Future getUser() async {
    var firebaseUser = await _auth.currentUser();
    return User(uid: firebaseUser.uid);
  }

  //sign in anon
  Future signinAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      //creates anonymous user via a firebase instance
      FirebaseUser user = result.user;
      //takes out the user

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.tostring());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String nickname,
      String gender,
      String block,
      String bio,
      String dp,
      bool isAnonymous,
      String media,
      String playlist,
      String course,
      String accoms) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create document for each user in registration
      await DatabaseService(uid: user.uid).uploadUserData(
          email, name, nickname, gender, block, bio, dp, isAnonymous,media,playlist,course,accoms);
      await DatabaseService(uid: user.uid).uploadWhoData(
          email: email,
          name: name,
          nickname: nickname,
          isAnonymous: isAnonymous,
          dp: dp,
          gender: gender,
          score: 0);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //validate curren password
  Future validatePassword(String password) async {
    var baseUser = await _auth.currentUser();

    // var authCrudentials = EmailAuthProvider.getCredential(
    //     email: firebaseUser.email, password: password);
    // print(authCrudentials);

    try {
      //sign in method is used instead of reauthenticate with credential because
      //it was buggy
      var firebaseUser = await _auth.signInWithEmailAndPassword(
          email: baseUser.email, password: password);
      return firebaseUser != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser();
    firebaseUser.updatePassword(password);
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
