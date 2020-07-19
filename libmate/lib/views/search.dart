import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final SearchBarController<BookCard> _searchBarController =
      SearchBarController();

  Future<List<BookCard>> onSearch(String search) async {
    print("searching");
    await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => new BookCard(
            shouldOpenPage: true,
            key: ValueKey(index.toString()),
            model: new BookModel(
              name: "$index on a Treasure Island",
              author: "Enid Blyton",
              isbn: "9785389130692",
              image:
                  "https://upload.wikimedia.org/wikipedia/en/e/ed/FiveOnATreasureIsland.jpg",
              subject: "Novel",
              genre: "Fiction",
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Search'),
      ),
      drawer: new AppDrawer(),
      body: SafeArea(
          child: SearchBar<BookCard>(
        searchBarStyle: SearchBarStyle(),
        onSearch: onSearch,
        searchBarController: _searchBarController,
        placeHolder: Text("Please enter minimum three characters"),
        emptyWidget: Text("No results found"),
        onItemFound: (BookCard book, int index) {
          return book;
        },
      )),
    );
  }
}
