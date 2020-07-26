import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';

class SearchPage extends StatefulWidget {
  final fuse;

  SearchPage({this.fuse});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final SearchBarController<BookCard> _searchBarController =
  SearchBarController();

  Future<List<BookCard>> onSearch(String search) async {
    await Future.delayed(Duration(seconds: 1));
    final result = widget.fuse.search(search);
    List<BookCard> disp = List();

    for (var res in result) {
      var added = BookCard(model: res.item);
      added.shouldOpenPage = true;
      disp.add(added);
    }
    return disp;
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
