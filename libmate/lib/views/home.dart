import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:redux/redux.dart';

class Home extends StatelessWidget {
  final Icon customIcon = Icon(Icons.search);
  final Widget customHeading = Text("LibMate");
  bool loggedIn;

  Home({ this.loggedIn });

  Widget getLoggedInBody() {
    return Text("Hello!");
  }

  Widget getLoggedOutBody() {
    return GAuthButton();
  }

  Widget getBody() {
    return loggedIn ? getLoggedInBody() : getLoggedOutBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customHeading,
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: getBody());
  }
}
