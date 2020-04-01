import 'package:flutter/material.dart';

import './drawer.dart';
import './bookcard.dart';

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
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return new BookCard(
            key: ValueKey(index.toString()),
            title: "Five on a Treasure Island",
            author: "Enid Blyton",
            isbn: "9785389130692",
            image: "https://upload.wikimedia.org/wikipedia/en/e/ed/FiveOnATreasureIsland.jpg",
          );
        }),
        childAspectRatio: 0.67,
      ),
      drawer: new AppDrawer(),
    );
  }
}
