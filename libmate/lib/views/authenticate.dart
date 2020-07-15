import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:libmate/views/sign_in.dart';
import 'package:libmate/views/drawer.dart';


class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Sign in'),

      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(30.0,40.0,30.0,0.0),
          child: SignIn(),
      ),

      drawer: AppDrawer(),
    );
  }

}