import 'package:flutter/material.dart';

import './search.dart';
import './guide.dart';
import './contribute.dart';
import './friends.dart';
import './goals.dart';
import './libcard.dart';
import './request.dart';
import './about.dart';
import './accounts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LibMate',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: MyHomePage(title: 'LibMate Home'),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new MyHomePage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: new Drawer(
          child: ListView(children: <Widget>[
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
                  builder: (BuildContext context) => new AboutPage(),
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
      ])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text('You Pressed $_counter Times',
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
