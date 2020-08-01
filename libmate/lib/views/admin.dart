import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Admin Page'),
      ),
      drawer: AppDrawer(),
      body: const WebView(
        initialUrl:
            'https://console.firebase.google.com/project/librarymanagement-366ac/analytics/app/android:iiit.occamsrazor.libmate/overview/~2F%3Ft%3D1596230450454&fpn%3D842844863088&swu%3D1&sgu%3D1&sus%3Dupgraded&cs%3Dapp.m.dashboard.overview&g%3D1',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
