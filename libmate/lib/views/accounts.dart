import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/actions.dart';
import 'package:libmate/datastore/auth.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:redux/redux.dart';

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
        title: new Text('Accounts'),
      ),
      drawer: AppDrawer(),
      body: Container(
        color: Colors.white,
        child: Center(child: buildState()),
      ),
    );
  }

  Widget buildState() {
    return StoreConnector<AppState, _AccountsViewModel>(
        converter: (Store<AppState> store) => _AccountsViewModel.create(store),
        builder: (BuildContext context, _AccountsViewModel model) =>
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            width: 75.0,
                            height: 75.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(model.photoUrl)))),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(model.name, textScaleFactor: 1.5),
                                Text(model.email, textScaleFactor: 1.0),
                              ],
                            )
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 3,
                      ),
                    ),
                GAuthButton(
                  callback: () {
                    model.logout();
                  },
                  text: 'Sign Out',
                ),
              ],
                )));
  }
}

class _AccountsViewModel {
  String name;
  String email;
  String photoUrl;

  final Function() logout;

  _AccountsViewModel({this.name, this.email, this.photoUrl, this.logout});

  factory _AccountsViewModel.create(Store<AppState> store) {
    void logOutThunk(Store<AppState> store) async {
      final UserModel userModel = await googleSignIn(false);
      store.dispatch(LogInAction(userModel));
    }

    return _AccountsViewModel(
      name: store.state.user.name,
      email: store.state.user.email,
      photoUrl: store.state.user.photoUrl,
      logout: () {
        logOutThunk(store);
      },
    );
  }
}
