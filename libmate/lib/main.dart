import 'package:libmate/datastore/model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/about.dart';
import 'package:libmate/views/accounts.dart';
import 'package:libmate/views/contribute.dart';
import 'package:libmate/views/friends.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/home.dart';
import 'package:libmate/views/libcard.dart';
import 'package:libmate/views/request.dart';
import 'package:libmate/views/search.dart';
import 'package:libmate/views/voiceSearch.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded;
  UserModel model;

  @override
  void initState() {
    super.initState();
    loaded = false;
    loadState();
  }

  void loadState() async {
    model = await UserModel.fromSharedPrefs();
    print(model.uid);

    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return MaterialApp(
          title: 'LibMate',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: Scaffold(
              appBar: AppBar(
                title: Text("LibMate"),
                centerTitle: true,
              ),
              body: Text("Loading")));
    }

    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (context) => model)],
        child: Consumer<UserModel>(builder: (context, usermodel, child) {
          return MaterialApp(
              title: 'LibMate',
              theme: ThemeData(
                primarySwatch: Colors.pink,
              ),
              initialRoute: "/home",
              routes: <String, WidgetBuilder>{

                '/home': (BuildContext context) =>
                    new Home(loggedIn: usermodel.isLoggedIn()),
                '/search': (BuildContext context) => new SearchPage(),
                '/voicesearch': (BuildContext context) => new VoiceSearchPage(),
                '/contribute': (BuildContext context) => new ContributePage(),
                '/friends': (BuildContext context) => new FriendsPage(),
                '/goals': (BuildContext context) => new GoalsPage(),
                '/libcard': (BuildContext context) => new LibcardPage(),
                '/request': (BuildContext context) => new RequestPage(),
                '/about': (BuildContext context) => new AboutPage(),
                '/accounts': (BuildContext context) => new AccountsPage(),
              });
        }));
  }
}
