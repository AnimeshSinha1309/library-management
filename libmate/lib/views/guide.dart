import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Guide Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
