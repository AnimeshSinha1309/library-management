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
        title: new Text('Accounts Page'),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GAuthButton(
                  callback: () {
                    model.logout();
                  },
                  text: 'Sign Out',
                ),
              ],
            ));
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
