import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('About Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
