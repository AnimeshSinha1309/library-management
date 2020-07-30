import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/about.dart';
import 'package:libmate/views/accounts.dart';
import 'package:libmate/views/contribute.dart';
import 'package:libmate/views/friends.dart';
import 'package:libmate/views/issue.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/home.dart';
import 'package:libmate/views/libcard.dart';
import 'package:libmate/views/request.dart';
import 'package:libmate/views/search.dart';
import 'package:libmate/views/speech.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:provider/provider.dart';
import 'package:libmate/views/guide.dart';
import 'package:libmate/views/razorpay.dart';
import 'package:libmate/views/razorpay.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded;
  UserModel model;
  var fuse;
  List<BookModel> books;

  @override
  void initState() {
    super.initState();
    loaded = false;
    loadState();
  }

  void loadBookData() {
    Firestore.instance.collection('books').getDocuments().then((snapshot) {
      final documents = snapshot.documents;
      books = List<BookModel>();

      for (var document in documents) {
        final name = document.data["name"];
        books.add(BookModel(name: name));
      }
    }).then((someRes) {
      final wk =
          WeightedKey(name: "keyer", getter: (obj) => obj.name, weight: 1);
      final fo = FuzzyOptions(keys: [wk]);
      fuse = Fuzzy(books, options: fo);
      // in fuse.search, score of 0 is fullmatch, 1 is complete mismatch
    });
  }

  void loadState() async {
    model = await UserModel.fromSharedPrefs();

    loadBookData();

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
                '/home': (BuildContext context) => new Home(),
                '/search': (BuildContext context) => new SearchPage(fuse: fuse),
                '/speech': (BuildContext context) => new Speech(),
                '/contribute': (BuildContext context) => new ContributePage(),
                '/friends': (BuildContext context) => new FriendsPage(),
                '/issue': (BuildContext context) => new IssuePage(),
                '/goals': (BuildContext context) => new GoalsPage(),
                '/libcard': (BuildContext context) => new LibcardPage(),
                '/request': (BuildContext context) => new RequestPage(),
                '/about': (BuildContext context) => new AboutPage(),
                '/accounts': (BuildContext context) => new AccountsPage(),
                '/guide': (BuildContext context) => new GuidePage(),
              });
        }));
  }
}
