import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/widgets/login.dart';
import 'package:redux/redux.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DrawerViewModel>(
        converter: (Store<AppState> store) => _DrawerViewModel.create(store),
        builder: (BuildContext context, _DrawerViewModel model) =>
            Drawer(
                child: ListView(children: <Widget>[
                  model.email != ''
                      ? UserAccountsDrawerHeader(
                    accountName: Text(model.name),
                    accountEmail: Text(model.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(model.photoUrl),
                    ),
                  )
                      : DrawerHeader(
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 70.0, 16.0, 16.0),
                        child: SignInButton(callback: () {
                          model.login();
                        },)
                    ),
                  ),
                  ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/home');
                      }),
                  ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Search'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/search');
                      }),
                  ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Guide'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/guide');
                      }),
                  ListTile(
                      leading: Icon(Icons.file_upload),
                      title: Text('Contribute Info'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/contribute');
                      }),
                  ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Friends'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/friends');
                      }),
                  ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text('Reading Goals'),
                      trailing: Chip(label: Text('13')),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/goals');
                      }),
                  ListTile(
                      leading: Icon(Icons.card_membership),
                      title: Text('Library Card'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/libcard');
                      }),
                  ListTile(
                      leading: Icon(Icons.library_add),
                      title: Text('Request Book'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/request');
                      }),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Accounts'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/accounts');
                      }),
                  ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/about');
                      }),
                ])
            )
    );
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
      final String searchResults = await Future.delayed(
        Duration(seconds: 1),
            () => "Search Results",
      );
      store.dispatch(searchResults);
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
