import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/reducers.dart';
import 'package:libmate/views/about.dart';
import 'package:libmate/views/accounts.dart';
import 'package:libmate/views/contribute.dart';
import 'package:libmate/views/friends.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/guide.dart';
import 'package:libmate/views/home.dart';
import 'package:libmate/views/libcard.dart';
import 'package:libmate/views/request.dart';
import 'package:libmate/views/search.dart';
import 'package:libmate/views/authenticate.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = Store<AppState>(
        appStateReducer,
      initialState: AppState.initialState(),
      middleware: [thunkMiddleware],
    );
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
        title: 'LibMate',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new MyHomePage(),
          '/authenticate': (BuildContext context) => new Authenticate(),
          '/search': (BuildContext context) => new SearchPage(),
          '/guide': (BuildContext context) => new GuidePage(),
          '/contribute': (BuildContext context) => new ContributePage(),
          '/friends': (BuildContext context) => new FriendsPage(),
          '/goals': (BuildContext context) => new GoalsPage(),
          '/libcard': (BuildContext context) => new LibcardPage(),
          '/request': (BuildContext context) => new RequestPage(),
          '/about': (BuildContext context) => new AboutPage(),
          '/accounts': (BuildContext context) => new AccountsPage(),
        })
    );
  }
}