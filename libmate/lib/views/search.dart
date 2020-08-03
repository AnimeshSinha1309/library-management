import 'dart:math' as math;

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libmate/datastore/model.dart';
import 'package:libmate/scache/data.dart';
import 'package:libmate/utils/utils.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/widgets/bookcard.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class Item {
  Item(this.name, this.icon);
  final String name;
  final Widget icon;
}

class SearchPage extends StatefulWidget {
  final fuse;

  SearchPage({this.fuse});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  List<Item> users = <Item>[
    Item(
        'General',
        Icon(
          Icons.book,
          color: const Color(0xFF167F67),
        )),
    Item(
      'Springer books',
      Image.asset("assets/springer.png", height: 50),
    ),
    Item(
      'Springer journals',
      Image.asset("assets/springer.png", height: 50),
    )
  ];

  Item selectedUser;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    selectedUser = users[0];
  }

  Widget getSelectMenu() {
    return DropdownButton<Item>(
      hint: Text("Select item"),
      value: selectedUser,
      onChanged: (Item Value) {
        setState(() {
          selectedUser = Value;
        });
      },
      items: users.map((Item user) {
        return DropdownMenuItem<Item>(
          value: user,
          child: Row(
            children: <Widget>[
              user.icon,
              SizedBox(
                width: 10,
              ),
              Text(
                user.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Search'),
        ),
        drawer: new AppDrawer(),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: SafeArea(
              left: true,
              right: true,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: buildField("Name of the Book", "title")),
                  SliverToBoxAdapter(child: buildQueryOptions()),
                  buildResultsPane(),
                ],
              ),
            )));
  }

  /// Results Display Segment:
  ///  Maintains and displays the results generated by the query
  ///  as book cards

  List<BookModel> data;
  List<BookModel> dataCached;
  bool searchLoading = false;

  void scheduleSearch() async {
    Map<String, String> query = Map<String, String>();

    var type = selectedUser.name;
    bool isSp = true;
    if (type == "Springer journals") {
      query["springer"] = "1";
    } else if (type == "Springer books") {
      query["springer"] = "0";
    } else
      isSp = false;

    searchControllers.forEach((key, value) {
      if (value.text.length > 0) query[key] = value.text;
    });

    // Reject if empty, otherwise start loading
    if (query.isEmpty) return;

    dataCached = searchCache(query);
    setState(() {
      searchLoading = true;
    });

    // Query the URL
    Uri url = Uri.http("54.83.31.83", "/query", query);
    final result = await http.get(url); // call api;
    if (result.statusCode != 200) {
      print('ERROR: Search did not return a 200 Server response code');
      return;
    }
    // Process the response
    var response = readBookData(result);
    List<BookModel> searchResults = List();
    for (var res in response) {
      searchResults.add(BookModel.fromJSON(json: res, isSp: isSp));
    }
    // Set the state again
    setState(() {
      data = searchResults;
      searchLoading = false;
    });
  }

  Widget buildResultsPane() {
    if (searchLoading || data == null || data.length == 0) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              BookCard(model: dataCached[index]),
          childCount: dataCached == null ? 0 : dataCached.length,
        ),
      );
    } else {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => BookCard(model: data[index]),
          childCount: data == null ? 0 : data.length,
        ),
      );
    }
  }

  /// Search Option Segment:
  ///  Deals with setting up the expanded windows, maintaining controllers
  ///  and putting together the query string

  Map<String, TextEditingController> searchControllers = Map();
  final _formKey = GlobalKey<FormState>();
  final _debouncer = Debouncer(milliseconds: 500);

  Future _listen(String id) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            searchControllers[id].text = val.recognizedWords;
            print(searchControllers[id].text);
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  buildField(String label, String id) {
    if (!searchControllers.containsKey(id)) {
      var controller = TextEditingController();
      controller.addListener(() {
        _debouncer.run(scheduleSearch);
      });
      searchControllers[id] = controller;
    }
    return TextFormField(
        decoration: InputDecoration(
            labelText: label,
            suffixIcon: new IconButton(
                onPressed: () async {
                  await _listen(id);
                },
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none))),
        controller: searchControllers[id]);
  }

  Widget buildQueryOptions() {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                expanded: Form(
                    key: _formKey,
                    child: Column(children: [
                      buildField("Author", "author"),
                      buildField("Category", "tag"),
                      buildField("Publisher", "publisher"),
                      getSelectMenu()
                    ])),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    searchControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
