import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Goals Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
