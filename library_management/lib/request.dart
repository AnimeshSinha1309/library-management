import 'package:flutter/material.dart';

import './drawer.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Request Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
