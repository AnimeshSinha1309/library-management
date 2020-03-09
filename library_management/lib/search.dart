import 'package:flutter/material.dart';

import './drawer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Search Page'),
      ),
      drawer: new AppDrawer(),
    );
  }
}
