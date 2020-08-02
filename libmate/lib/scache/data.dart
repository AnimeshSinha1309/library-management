import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:libmate/datastore/model.dart';

List<dynamic> searchData;

Future loadSCache() async {
  final input = await rootBundle.loadString('assets/books-data.json');
  searchData = json.decode(input);
}

List<BookModel> searchCache(Map query) {
  var book1 = BookModel.fromJSON(json: searchData[0]);
  var book2 = BookModel.fromJSON(json: searchData[1]);
  var book3 = BookModel.fromJSON(json: searchData[2]);
  var result = <BookModel>[book1, book2, book3];
  return result;
}
