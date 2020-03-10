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
      body: new ListView.builder(
        padding: const EdgeInsets.all(16),
        /// Scrolling List of results
        itemBuilder: (context, i) {
          return Container(
            height: 130,
            child: Card(
              elevation: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        return;
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      return;
                    },
                    child: Container(
                        padding: EdgeInsets.all(30.0),
                        child: Chip(
                          label: Text('@book'),
                          backgroundColor: Colors.yellow,
                          elevation: 2,
                          autofocus: true,
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: new AppDrawer(),
    );
  }
}
