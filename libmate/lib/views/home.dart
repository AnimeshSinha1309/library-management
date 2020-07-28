import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';

class Home extends StatelessWidget {
  final Icon customIcon = Icon(Icons.search);
  final Widget customHeading = Text("LibMate");
  bool loggedIn;

  Home({ this.loggedIn });

  Widget getLoggedInBody() {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(5),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Your Personalized Library Buddy",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.grey[600],
              ),
            ),
            Image.asset('assets/bgbook.jpg'),
     ])
    );
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
