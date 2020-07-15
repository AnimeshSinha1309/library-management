import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:redux/redux.dart';
import 'package:libmate/services/auth.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("LibMate");
  final AuthService _auth = AuthService();

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
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ]
        ),
        drawer: AppDrawer(),
        body: StoreConnector<AppState, _HomeViewModel>(
            converter: (Store<AppState> store) => _HomeViewModel.create(store),
            builder: (BuildContext context, _HomeViewModel model) => Container(
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
                            children: books.map((book) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("$book"),
                                    Center(
                                      child: RaisedButton.icon(
                                        onPressed: () {},
                                        color: Colors.amber,
                                        icon: Icon(Icons.launch),
                                        label: Text('Resume'),
                                      ),
                                    ),
                                  ]);
                            }).toList()),
                      ]),
                )));
  }
}

class _HomeViewModel {
  String name;
  String email;

  _HomeViewModel({this.name, this.email});

  factory _HomeViewModel.create(Store<AppState> store) {
    return _HomeViewModel(
        name: store.state.user.name, email: store.state.user.email);
  }
}
