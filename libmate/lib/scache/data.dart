import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:fuzzy/fuzzy.dart';
import 'package:libmate/datastore/model.dart';

List<dynamic> searchData;
var fuse;

Future loadSCache() async {
  final input = await rootBundle.loadString('assets/books-data.json');
  searchData = json.decode(input);
  fuse = Fuzzy(searchData,
      options: FuzzyOptions(keys: [
        WeightedKey(name: "keyer", getter: (obj) => obj["name"], weight: 1)
      ]));
}

List<BookModel> searchCache(Map query) {
  String queryString = "";
//  query.forEach((key, value) {
//    if (value.length > 0) queryString += value.text + ' ';
//  });
  var result = fuse.search("light");
  return result;
}
