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
      options: FuzzyOptions(keys: [
        WeightedKey(
            name: "name_key", getter: (BookModel o) => o.name, weight: 1 - 1.0),
        WeightedKey(
            name: "author_key",
            getter: (BookModel o) => o.author,
            weight: 1 - 0.4),
        WeightedKey(
            name: "desc_key",
            getter: (BookModel o) => o.description,
            weight: 1 - 0.2),
        WeightedKey(
            name: "genre_key",
            getter: (BookModel o) => o.genre + ' ' + o.subject,
            weight: 1 - 0.8),
      ]));
}

List<BookModel> searchCache(Map query) {
  String searchString = "";
  query.forEach((key, value) {
    if (key != "springer") searchString += value + ' ';
  });
  var result = fuse.search(searchString);
  List<BookModel> ans = [];
  for (var item in result) {
    ans.add(item.item);
  }
  return ans;
}
