import 'package:flutter/material.dart';

import './main.dart';
import './search.dart';
import './guide.dart';
import './contribute.dart';
import './friends.dart';
import './goals.dart';
import './libcard.dart';
import './request.dart';
import './about.dart';
import './accounts.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: new ListView(children: <Widget>[
      new UserAccountsDrawerHeader(
        accountName: new Text('John Doe'),
        accountEmail: new Text('test@mail.com'),
        currentAccountPicture: new CircleAvatar(
          backgroundImage: new NetworkImage('https://i.pravatar.cc/300'),
        ),
      ),
      new ListTile(
          leading: Icon(Icons.home),
          title: new Text('Home'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new MyHomePage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.search),
          title: new Text('Search'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new SearchPage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.location_on),
          title: new Text('Guide'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new GuidePage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.file_upload),
          title: new Text('Contribute Info'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new ContributePage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.people),
          title: new Text('Friends'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new FriendsPage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.library_books),
          title: new Text('Reading Goals'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new GoalsPage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.card_membership),
          title: new Text('Library Card'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new LibcardPage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.library_add),
          title: new Text('Request Book'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new RequestPage(),
              ),
            );
          }),
      new Divider(
        color: Colors.grey,
        thickness: 0.5,
      ),
      new ListTile(
          leading: Icon(Icons.account_circle),
          title: new Text('Accounts'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new AccountsPage(),
              ),
            );
          }),
      new ListTile(
          leading: Icon(Icons.info),
          title: new Text('About'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new AboutPage(),
              ),
            );
          }),
    ]));
  }
}
