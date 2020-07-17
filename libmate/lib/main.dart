import 'package:libmate/datastore/model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/about.dart';
import 'package:libmate/views/contribute.dart';
import 'package:libmate/views/friends.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/guide.dart';
import 'package:libmate/views/home.dart';
import 'package:libmate/views/libcard.dart';
import 'package:libmate/views/request.dart';
import 'package:libmate/views/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => UserModel())],
        child: Consumer<UserModel>(
            builder: (context, usermodel, child) {
              return MaterialApp(
                  title: 'LibMate',
                  theme: ThemeData(
                    primarySwatch: Colors.pink,
                  ),
                  initialRoute: "/home",
                  routes: <String, WidgetBuilder>{
                    '/home': (BuildContext context) => new Home(loggedIn: usermodel.isLoggedIn()),
                    '/search': (BuildContext context) => new SearchPage(),
                    '/guide': (BuildContext context) => new GuidePage(),
                    '/contribute': (BuildContext context) =>
                    new ContributePage(),
                    '/friends': (BuildContext context) => new FriendsPage(),
                    '/goals': (BuildContext context) => new GoalsPage(),
                    '/libcard': (BuildContext context) => new LibcardPage(),
                    '/request': (BuildContext context) => new RequestPage(),
                    '/about': (BuildContext context) => new AboutPage(),
                    // '/accounts': (BuildContext context) => new AccountsPage(),
                  });
            }));
  }
}
