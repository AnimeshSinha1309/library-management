import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:fuzzy/fuzzy.dart';
import 'package:libmate/datastore/model.dart';

List<BookModel> searchData;
var fuse;

Future loadSCache() async {
  final input = await rootBundle.loadString('assets/books-data.json');
  List<dynamic> searchRaw = json.decode(input);
  searchData = searchRaw
      .map<BookModel>((item) => BookModel.fromJSON(json: item))
      .toList();
  fuse = Fuzzy(searchData,
      options: FuzzyOptions(
          keys: [WeightedKey(name: "keyer", getter: getter, weight: 1)]));
}

String getter(BookModel object) {
  return object.name;
}

List<BookModel> searchCache(Map query) {
  var result = fuse.search("light");
  List<BookModel> ans = [];
  for (var item in result) {
    ans.add(item.item);
  }
  return ans;
}
