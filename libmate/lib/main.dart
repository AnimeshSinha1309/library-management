import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/views/about.dart';
import 'package:libmate/views/accounts.dart';
import 'package:libmate/views/contribute.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/home.dart';
import 'package:libmate/views/admin.dart';
import 'package:libmate/views/issue.dart';
import 'package:libmate/views/libcard.dart';
import 'package:libmate/views/request.dart';
import 'package:libmate/views/requested.dart';
import 'package:libmate/views/search.dart';
import 'package:libmate/views/speech.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:provider/provider.dart';
import 'package:libmate/views/guide.dart';
import 'package:libmate/views/journals.dart';
import 'package:libmate/widgets/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded;
  int loadingComps;
  UserModel model;

  void callback() {
    loadingComps++;
    print("Called $loadingComps");
    if (loadingComps == 2) {
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loaded = false;
    loadingComps = 0;
    loadState(callback);
    loadBooks(callback);
  }

  void loadState(Function callback) {
    void loader() async {
      model = await UserModel.fromSharedPrefs();
      await loadUser(model);
      callback();
    }

    void logouter() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("logged_in", false);
      prefs.remove("issuecart");
      loader();
    }

    // to avoid clogging up initStae

    // logouter();
    loader();
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
                '/home': (BuildContext context) => new Home(),
                '/admin': (BuildContext context) => new AdminPage(),
                '/libcard': (BuildContext context) => new LibcardPage(),
                '/search': (BuildContext context) => new SearchPage(),
                '/speech': (BuildContext context) => new Speech(),
                '/contribute': (BuildContext context) => new ContributePage(),
                '/issue': (BuildContext context) => new IssuePage(),
                '/goals': (BuildContext context) => new GoalsPage(),
                '/journal': (BuildContext context) => new JournalPage(),
                '/request': (BuildContext context) => new RequestPage(),
                '/requested': (BuildContext context) => new RequestedPage(),
                '/about': (BuildContext context) => new AboutPage(),
                '/accounts': (BuildContext context) => new AccountsPage(),
                '/guide': (BuildContext context) =>
                    new GuidePage(currentUser: usermodel),
                '/cart': (BuildContext context) => new BookCartUI(usermodel)
              });
        }));
  }
}
