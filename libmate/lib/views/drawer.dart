import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/auth.dart';
import 'package:libmate/widgets/gauth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (BuildContext context, UserModel model, Widget child) {
      var firstChild;

      if (model.isLoggedIn()) {
        firstChild = UserAccountsDrawerHeader(
          accountName: Text(model.name + "  (" + model.role + ")"),
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
              child: GAuth()),
        );
      }

      final secondChild = model.isLoggedIn()
          ? loggedInDrawerList(context)
          : loggedOutDrawerList(context);

      return Drawer(
          child: ListView(children: <Widget>[firstChild] + secondChild));
    });
  }

  List<Widget> loggedInDrawerList(context) {
    return <Widget>[
      _DrawerViewItem(Icons.home, 'Home', '/home').build(context),
      _DrawerViewItem(Icons.shop, 'Issue cart', '/cart').build(context),
      _DrawerViewItem(Icons.search, 'Search', '/search').build(context),
      _DrawerViewItem(Icons.location_on, 'Guide', '/guide').build(context),
      _DrawerViewItem(Icons.bookmark_border, 'Auto Tagger', '/autoTagger')
          .build(context),
      _DrawerViewItem(Icons.library_books, 'Reading List', '/goals')
          .build(context),
      _DrawerViewItem(Icons.card_membership, 'Library Card', '/libcard')
          .build(context),
      _DrawerViewItem(Icons.library_add, 'Request Books', '/request')
          .build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(Icons.view_carousel, 'Book Requests', '/requested')
          .build(context),
      _DrawerViewItem(Icons.access_time, 'Get time slot', '/appointment')
          .build(context),
      _DrawerViewItem(Icons.center_focus_weak, 'Admin', '/admin')
          .build(context),
      _DrawerViewItem(Icons.camera, 'Admin Scan and issue', '/admin_scan')
          .build(context),
      _DrawerViewItem(
              Icons.calendar_view_day, 'Upcoming periodicals', '/schedule')
          .build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(Icons.file_upload, 'Contribute Info', '/contribute')
          .build(context),
      _DrawerViewItem(Icons.account_circle, 'Accounts', '/accounts')
          .build(context),
      _DrawerViewItem(Icons.info, 'About', '/about').build(context),
    ];
  }

  List<Widget> loggedOutDrawerList(context) {
    return <Widget>[
      //(login doesnt work) for testing other features start:
      _DrawerViewItem(Icons.home, 'Home', '/home').build(context),
      _DrawerViewItem(Icons.home, 'Admin', '/admin').build(context),
      _DrawerViewItem(Icons.shop, 'Issue cart', '/cart').build(context),
      _DrawerViewItem(Icons.camera, 'Admin Scan and issue', '/admin_scan')
          .build(context),
      _DrawerViewItem(Icons.search, 'Search', '/search').build(context),
      _DrawerViewItem(Icons.location_on, 'Guide', '/guide').build(context),
      _DrawerViewItem(Icons.bookmark_border, 'Auto Tagger', '/autoTagger')
          .build(context),
      _DrawerViewItem(Icons.library_books, 'Reading List', '/goals')
          .build(context),
      _DrawerViewItem(Icons.card_membership, 'Library Card', '/libcard')
          .build(context),
      _DrawerViewItem(Icons.library_add, 'Request Books', '/request')
          .build(context),
      _DrawerViewItem(Icons.library_add, 'Book Requests', '/requested')
          .build(context),
      _DrawerViewItem(Icons.access_time, 'Get time slot', '/appointment')
          .build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(
              Icons.calendar_view_day, 'Upcoming periodicals', '/schedule')
          .build(context),
      _DrawerViewItem(Icons.location_on, 'Periodical Page', '/periodical').build(context),
      Divider(color: Colors.grey, thickness: 0.5),
      _DrawerViewItem(Icons.file_upload, 'Contribute Info', '/contribute')
          .build(context),
      _DrawerViewItem(Icons.account_circle, 'Accounts', '/accounts')
          .build(context),
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
