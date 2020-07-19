import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';

class Home extends StatelessWidget {
  final Icon customIcon = Icon(Icons.search);
  final Widget customHeading = Text("LibMate");
  bool loggedIn;

  Home({ this.loggedIn });

  Widget getLoggedInBody() {
    return Text("Hello!");
  }

  Widget getLoggedOutBody() {
    return GAuth();
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
