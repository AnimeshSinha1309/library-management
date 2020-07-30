import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Requests for Issue"),
      appBar: new AppBar(
        title: new Text('Issue Requests'),
      ),
      drawer: AppDrawer(),
    );
  }
}
