import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:libmate/views/sign_in.dart';

import 'package:libmate/views/register.dart';
import 'package:libmate/views/drawer.dart';


class Authenticate extends StatefulWidget{

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn)
      {
        return SignIn(toggleView: toggleView);
      }
    else{
      return Register(toggleView: toggleView);
    }

  }

}