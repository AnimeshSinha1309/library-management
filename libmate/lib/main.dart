import 'package:flutter/material.dart';

import './drawer.dart';
import './search.dart';
import './guide.dart';
import './contribute.dart';
import './friends.dart';
import './goals.dart';
import './bookerzCard.dart';
import './request.dart';
import './about.dart';
import './accounts.dart';
import './libCard.dart';

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
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new MyHomePage(),
          '/search': (BuildContext context) => new SearchPage(),
          '/guide': (BuildContext context) => new GuidePage(),
          '/contribute': (BuildContext context) => new ContributePage(),
          '/friends': (BuildContext context) => new FriendsPage(),
          '/goals': (BuildContext context) => new GoalsPage(),
          '/bookerzcard': (BuildContext context) => new BookerzcardPage(),
          '/libcard': (BuildContext context) => new LibcardPage(),
          '/request': (BuildContext context) => new RequestPage(),
          '/about': (BuildContext context) => new AboutPage(),
          '/accounts': (BuildContext context) => new AccountsPage(),
//          '/recommendedBooks': (BuildContext context) => new RecommenderPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

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
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("LibMate");

  @override
  Widget build(BuildContext context) {
    List<String> books = [
    "Linear Algebra: Strang",
      "To Kill a Mockingbird",
      "Algorithms: Cormen"
    ];

    return Scaffold(
      appBar: AppBar(
        title: cusSearchBar,
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Container(
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
          Center(
            child: Text(
              "My books",
              style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.grey[600],
            ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: books.map((book){
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                  Text("$book"),
                  Center(
                  child: RaisedButton.icon(
                  onPressed: (){},
                  color: Colors.amber,
                  icon: Icon(Icons.launch),
                  label: Text('Resume'),
                  ),
                  ),

              ]);
              }).toList()),
            ]),
        )
    );

  }
}



