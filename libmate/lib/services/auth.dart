import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/sign_in.dart';
import 'package:libmate/models/user.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid): null;
  }
  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    .map((FirebaseUser user) => _userFromFirebaseUser(user));
//        .map(_userFromFirebaseUser);
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //signin anon
  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toSting());
      return null;

    }

  }

}

Future<UserModel> googleSignIn(bool login) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  if (login) {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
    await FirebaseAuth.instance.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);

    return UserModel(
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
        uid: user.uid);
  } else {
    await googleSignIn.signOut();
    return UserModel(name: '', email: '', photoUrl: '', uid: '');
  }
}


class AuthDataService {


  //sign in with google
  void createEntry(data) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection("users")
        .document(firebaseUser.uid)
        .setData(data)
        .then((value) {
      print("User Data was successfully Committed to the servers");
    });
  }

  void updateEntry(data) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection("users")
        .document(firebaseUser.uid)
        .setData(data)
        .then((value) {
      print("User Data was successfully Committed to the servers");
    });
    //sign in with email password

  }
}