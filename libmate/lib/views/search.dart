import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:libmate/datastore/model.dart';
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
  Widget searchResults =
      Text("No query yet, search starts as soon as you start typing!");
  Widget searchOptions;

  @override
  void initState() {
    super.initState();
    searchOptions = SearchOptions(scheduleSearch);
  }

  Future<Widget> onSearch(String queryUrl) async {
    await Future.delayed(Duration(seconds: 1));
    print("Querying: $queryUrl");
    final result = await http.get(queryUrl); // call api;

    if (result.statusCode == 200) {
      String resp = result.body.replaceAllMapped(RegExp(r"NaN,"), (match) {
        return "\"\",";
      });
      var booklist = json.decode(resp);
      if (booklist.length == 0) return emptyWidget;

      List<BookCard> disp = List();

      for (var res in booklist) {
        var added = BookCard(model: BookModel.fromJSON(res));
        added.shouldOpenPage = true;
        disp.add(added);
      }

      return Column(children: disp);
    } else {
      return Text("Application error!");
    }
  }

  void scheduleSearch(Map<String, String> data) async {
    setState(() {
      searchResults = CircularProgressIndicator();
    });

    String query = "https://libmate.herokuapp.com/query?maxResults=5";
    bool seenany = false;

    data.forEach((key, value) {
      if (value == "") return;

      seenany = true;
      query += "&$key=$value";
    });

    if (!seenany) return;

    var res = await onSearch(query);
    setState(() {
      searchResults = res;
    });
  }

  Widget build(BuildContext build) {
    return ListView(children: [searchOptions, searchResults]);
  }
}

class SearchOptions extends StatefulWidget {
  final Function scheduleSearch;
  final _debouncer = Debouncer(milliseconds: 500);

  SearchOptions(this.scheduleSearch);

  createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  Map<String, TextEditingController> mapper = Map();

  aggregateAndQuery() {
    // collect fields and call the callback
    Map<String, String> data = mapper.map((key, controller) {
      return MapEntry(key, controller.text);
    });
    widget.scheduleSearch(data);
  }

  buildField(String text, String shortname) {
    var controller = TextEditingController();
    controller.addListener(() {
      widget._debouncer.run(aggregateAndQuery);
    });

    mapper[shortname] = controller;
    return TextFormField(
        decoration: InputDecoration(labelText: text), controller: controller);
  }

  buildList() {
    TextFormField author = buildField("Author name", "author");
    TextFormField category = buildField("Category name", "tag");
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
