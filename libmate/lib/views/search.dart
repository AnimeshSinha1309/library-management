import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:libmate/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final fuse;

  SearchPage({this.fuse});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Search'),
        ),
        drawer: new AppDrawer(),
        body: SafeArea(child: Searcher()));
  }
}

class Searcher extends StatefulWidget {
  createState() => _SearcherState();
}

class _SearcherState extends State<Searcher> {
  final emptyWidget = Text("No results found");
  Widget searchResults;

  Future<Widget> onSearch(String queryUrl) async {
    await Future.delayed(Duration(seconds: 1));
    final result = await http.get(queryUrl); // call api;

    if (result.statusCode == 200) {
      var booklist = json.decode(result.body);
      if (booklist.length == 0) return emptyWidget;

      List<BookCard> disp = List();
      print(booklist);

      for (var res in booklist) {
        var added = BookCard(model: res.item);
        added.shouldOpenPage = true;
        disp.add(added);
      }

      return Column(children: disp);
    } else {
      return Text("Application error!");
    }
  }

  void updateSearch(Map<String, String> data) async {
    String query = "https://libmate.herokuapp.com/query";
    bool first = true;

    data.forEach((key, value) {
      if (value == "") return;

      if (first)
        query += "?$key=$value";
      else
        query += "&$key=$value";
      first = false;
    });

    searchResults = await onSearch(query);
  }

  Widget build(BuildContext build) {
    return Column(children: [SearchOptions(updateSearch), searchResults]);
  }
}

class SearchOptions extends StatefulWidget {
  final Function updateSearch;
  final _debouncer = Debouncer(milliseconds: 500);

  SearchOptions(this.updateSearch);

  createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  Map<String, TextEditingController> mapper;

  aggregateAndQuery() {
    // collect fields and call the callback
    Map<String, String> data = mapper.map((key, controller) {
      return MapEntry(key, controller.text);
    });
    widget.updateSearch(data);
  }

  buildField(String text, String shortname) {
    var controller = TextEditingController();
    controller.addListener(() {
      widget._debouncer.run(aggregateAndQuery());
    });

    return TextFormField(
        decoration: InputDecoration(labelText: text), controller: controller);
  }

  buildList() {
    TextFormField author = buildField("Author name", "author");
    TextFormField category = buildField("Category name", "category");
    TextFormField publisher = buildField("Publisher name", "publisher");

    return Column(children: [author, category, publisher]);
  }

  buildAdvancedOptions(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Colors.indigoAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.white,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Advanced options",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  searchTitle() {
    var search = buildField("Book title", "title");

    return search;
  }

  @override
  void dispose() {
    mapper.forEach((_, controller) {
      controller.dispose();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [searchTitle(), buildAdvancedOptions(context)]);
  }
}
