import 'package:flutter/material.dart';

import './drawer.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contribute Page'),
      ),
      drawer: AppDrawer(),
    );
  }
}
