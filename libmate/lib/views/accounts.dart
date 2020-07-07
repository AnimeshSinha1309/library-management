import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/login.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  bool loggedIn;

  @override
  void initState() {
    super.initState();
    loggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Accounts Page'),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: Colors.white,
        child: Center(child: buildState()),
      ),
    );
  }

  Widget buildState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
//        CircleAvatar(
//          backgroundImage: NetworkImage(
//            imageUrl,
//          ),
//          radius: 60,
//          backgroundColor: Colors.transparent,
//        ),
        SizedBox(height: 40),
        Text(
          'NAME',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
//        Text(
//          name,
//          style: TextStyle(
//              fontSize: 25,
//              color: Colors.deepPurple,
//              fontWeight: FontWeight.bold),
//        ),
        SizedBox(height: 20),
        Text(
          'EMAIL',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
//        Text(
//          email,
//          style: TextStyle(
//            fontSize: 15,
//            color: Colors.grey,
//          ),
//        ),
        SizedBox(height: 40),
        SignOutButton(
            callback: () => setState(() {
                  loggedIn = false;
                })),
      ],
    );
  }
}
