import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/actions.dart';
import 'package:libmate/services/auth.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:redux/redux.dart';
//import 'package:provider/provider.dart';
//import 'package:libmate/models/user.dart';


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DrawerViewModel>(
        converter: (Store<AppState> store) => _DrawerViewModel.create(store),
        builder: (BuildContext context, _DrawerViewModel model) {
          var firstChild;
          if (model.email != null) {
            firstChild = UserAccountsDrawerHeader(
              accountName: Text(model.name),
              accountEmail: Text(model.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(model.photoUrl),
              ),
            );
          } else {
            firstChild = DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 70.0, 16.0, 16.0),
                  child: GAuthButton(
                    callback: () {
                      model.login();
                    },
                  )),
            );
          }
//          final user = Provider.of<User>(context);
          
          final secondChild =
          model.email != null ? loggedInDrawerList() : loggedOutDrawerList();

          return Drawer(
              child: ListView(children: <Widget>[firstChild] + secondChild));
        });
  }

  List<Widget> loggedInDrawerList() {
    return <Widget>[
      _DrawerViewItem(Icons.home, 'Home', '/home').build(context),
      _DrawerViewItem(Icons.search, 'Search', '/search').build(context),
      _DrawerViewItem(Icons.location_on, 'Guide', '/guide').build(context),
      _DrawerViewItem(Icons.file_upload, 'Contribute Info', '/contribute')
          .build(context),
      _DrawerViewItem(Icons.people, 'Friends', '/friends').build(context),
      _DrawerViewItem(Icons.library_books, 'Reading Goals', '/goals')
          .build(context),
      _DrawerViewItem(Icons.card_membership, 'Library Card', '/libcard')
          .build(context),
      _DrawerViewItem(Icons.library_add, 'Request Books', '/request')
          .build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(Icons.account_circle, 'Accounts', '/accounts')
          .build(context),
      _DrawerViewItem(Icons.info, 'About', '/about').build(context),
    ];
  }

  List<Widget> loggedOutDrawerList() {
    return <Widget>[
      _DrawerViewItem(Icons.person, 'Sign in', '/authenticate').build(context),
      _DrawerViewItem(Icons.location_on, 'Guide', '/guide').build(context),
      _DrawerViewItem(Icons.file_upload, 'Contribute Info', '/contribute').build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(Icons.info, 'About', '/about').build(context),
    ];
  }
}



class _DrawerViewItem {
  IconData icon;
  String name;
  String path;

  _DrawerViewItem(this.icon, this.name, this.path);

  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(this.icon),
        title: Text(this.name),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, this.path);
        });
  }
}

class _DrawerViewModel {
  String name;
  String email;
  String photoUrl;

  final Function() login;

  _DrawerViewModel({this.name, this.email, this.photoUrl, this.login});

  factory _DrawerViewModel.create(Store<AppState> store) {
    void logInThunk(Store<AppState> store) async {
      final UserModel userModel = await googleSignIn(true);
      store.dispatch(LogInAction(userModel));
    }

    return _DrawerViewModel(
      name: store.state.user.name,
      email: store.state.user.email,
      photoUrl: store.state.user.photoUrl,
      login: () {
        logInThunk(store);
      },
    );
  }
}
