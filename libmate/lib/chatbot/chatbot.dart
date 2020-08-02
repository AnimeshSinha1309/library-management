import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fuzzy/fuzzy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libmate/datastore/model.dart';

String readUser() {
  return stdin.readLineSync();
}

class ChatBook {
  String name, author;
  String tag, isbn, description;

  ChatBook({this.name, this.author, this.tag, this.isbn, this.description});

  ChatBook.fromJSON(Map<String, dynamic> data) {
    name = data["title"];
    author = data["author"];
  }
}

class Chatbot {
  dynamic subjectsFuse;
  dynamic authorsFuse;
  List<String> actions = ["recommend", "suggest", "give"];
  dynamic helloFuse;
  dynamic actionFuse;
  List<ChatBook> books;
  Map<String, int> mapper;
  List<String> authorWhiteList;
  List<String> tagWhitelist;
  dynamic comboFuse;

  int context;

  Chatbot() {
    var greetings = ["hello", "hi", "hey", "yo"];
    helloFuse = Fuzzy(greetings);
    actionFuse = Fuzzy(actions);

    context = 0;
  }

  List<String> extractData(
      dynamic dataFuse, List<String> strTokens, List<String> whiteList,
      {Map<String, double> scores}) {
    final maxReturns = 3;
    final scoreThresh = 0.7;

    var distinctTokens = strTokens.toSet().toList();
    if (scores == null) scores = Map();

    for (var token in distinctTokens) {
      if (new RegExp(r"^\s*$").hasMatch(token)) continue;
      // if (!whiteList.contains(token)) continue;
      var res = dataFuse.search(token); // item, score relevant to us

      // print("==+++++== $token");
      // for (var item in res) {
      //   print(
      //       "${item.item.name} ${item.score.toStringAsFixed(3)} ${item.item.tag} ${item.item.author}");
      // }
      for (var row in res) {
        var item = row.item;
        scores[item.isbn] = (scores[item.isbn] ?? 0) + row.score;
      }
    }

    var keysDesc = scores.keys.toList()
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    if (keysDesc.length > maxReturns) {
      keysDesc = keysDesc.sublist(0, maxReturns);
    }
    // for (var key in keysDesc) {
    //   print("$key ${scores[key]}");
    // }

    return keysDesc;
  }

  bool sanityCheck(List<String> userTokens) {
    final threshold = 0.5;

    for (var token in userTokens) {
      var res = actionFuse.search(token);

      if (!res.isEmpty && res[0].score < threshold) return true;
    }
    return false;
  }

  bool helloCheck(List<String> userTokens) {
    final threshold = 0.5;

    for (var token in userTokens) {
      var res = helloFuse.search(token);

      if (!res.isEmpty && res[0].score < threshold) return true;
    }
    return false;
  }

  dynamic readBookData(response) {
    var usable_body = response.body.replaceAllMapped(RegExp(r"NaN,"), (match) {
      return "\"\",";
    });
    usable_body =
        usable_body.replaceAllMapped(RegExp(r'(, )?"\w+": NaN'), (match) {
      return "";
    });

    return json.decode(usable_body);
  }

  Future<List<ChatBook>> search(
      List<ChatBook> authors, List<ChatBook> subjects) async {
    var authorNames = authors.map<String>((x) => x.author).toList();
    var tagNames = subjects.map<String>((x) => x.tag).toList();

    Map<String, double> scores;
    extractData(authorsFuse, authorNames, authorWhiteList, scores: scores);
    var finalRes =
        extractData(subjectsFuse, tagNames, tagWhitelist, scores: scores);

    List<ChatBook> output = [];
    for (var res in finalRes) {
      output.add(books[mapper[res]]);
    }

    return output;
  }

  List<String> stopwordRemoval(List<String> tokens) {
    List<String> ret = [];
    for (var token in tokens) {
      if (tagWhitelist.contains(token) || authorWhiteList.contains(token))
        ret.add(token);
    }
    return ret;
  }

  // context = 0 => greeting, ask for book recommendation
  // context = 1 => book recommendation shown

  dynamic giveInput(String userInput) async {
    var tokens = userInput.split(" ");
    bool hello = helloCheck(tokens);

    if (context == 0 && !sanityCheck(tokens)) {
      return [
        hello ? "Hi there!" : "Sorry I do not understand that.",
        "Try asking me to 'recommend a maths book' or 'give a good book by michael nielsen about quantum physics'"
      ];
    }

    List<String> newtokens = stopwordRemoval(tokens);
    String query = newtokens.join(" ");
    newtokens.reversed.join(" ");

    var data = comboFuse.search(query);

    print(query);

    for (int i = 0; i < 10; i++) {
      var item = data[i];
      print(
          "${item.item.name} ${item.score.toStringAsFixed(3)} ${item.item.tag} ${item.item.author}");
    }

    query = newtokens.reversed.join(" ");

    data = comboFuse.search(query);

    print(query);

    for (int i = 0; i < 10; i++) {
      var item = data[i];
      print(
          "${item.item.name} ${item.score.toStringAsFixed(3)} ${item.item.tag} ${item.item.author}");
    }

    List<String> output = [];
    if (hello) output.add("Hey there!");

    print("subjs");
    var detectedSubjects = extractData(subjectsFuse, tokens, tagWhitelist);
    print("authors");
    var detectedAuthors = extractData(authorsFuse, tokens, authorWhiteList);
    print("Detected stuff");
    print(detectedAuthors);
    print(detectedSubjects);

    output.add("Recommending books based on");
    String author = "Authors: ";
    String subjects = "Subjects: ";

    int i = 0;
    for (var a in detectedAuthors) {
      if (i > 0) author += ", ";
      author += books[mapper[a]].author;
      i++;
    }
    i = 0;
    for (var s in detectedSubjects) {
      if (i > 0) subjects += ", ";
      subjects += books[mapper[s]].tag;
      i++;
    }
    if (detectedAuthors.length == 0) author += "none";
    if (detectedSubjects.length == 0) subjects += "none";

    output.add(author + "; " + subjects);

    var detA = detectedAuthors.map<ChatBook>((x) => books[mapper[x]]).toList();
    var detS = detectedSubjects.map<ChatBook>((x) => books[mapper[x]]).toList();
    var result = await search(detA, detS);

    if (result.length == 0) {
      output.add("Sorry, I could not find any books related to that criteria");
    } else {
      for (var book in result) {
        output.add("Title: ${book.name} by ${book.author}");
      }
    }

    return output;
  }

  dynamic getWelcome() {
    return [
      "Welcome to the chatbot",
      "You can ask me to recommend/suggest/give you a book"
    ];
  }

  Future<void> loadDb() async {
    final input = await rootBundle.loadString('assets/db.json');
    dynamic db = jsonDecode(input);

    books = List();
    mapper = Map();
    authorWhiteList = [];
    tagWhitelist = [];

    var splitReg = RegExp(r";|\s");
    for (int i = 0; i < db['id'].length; i++) {
      var idx = i.toString();
      var author = db['author'][idx];
      var name = db['title'][idx];
      var isb = db['isbn'][idx];
      var desc = db['description'][idx];
      var tag = db['tag'][idx];
      if (name == null || author == null || isb == null || desc == null)
        continue;
      authorWhiteList.addAll(author.split(splitReg));
      tagWhitelist.addAll(tag.split(splitReg));
      if (i < 10) {
        print("$author $name $tag $isb");
      }

      var isbn = isb.toInt().toString();
      var entry = ChatBook(
          name: name, author: author, description: desc, tag: tag, isbn: isbn);
      mapper[isbn] = books.length;
      books.add(entry);
    }

    subjectsFuse = Fuzzy(books,
        options: FuzzyOptions(keys: [
          WeightedKey(name: "tag", getter: (ChatBook o) => o.tag, weight: 0)
        ]));
    authorsFuse = Fuzzy(books,
        options: FuzzyOptions(keys: [
          WeightedKey(
              name: "author",
              getter: (ChatBook o) => o.author.replaceAll(RegExp(r";"), " "),
              weight: 0)
        ]));
    comboFuse = Fuzzy(books,
        options: FuzzyOptions(keys: [
          WeightedKey(
              name: "author",
              getter: (ChatBook o) => o.author.replaceAll(RegExp(r";"), " "),
              weight: 0),
          WeightedKey(
              name: "tag",
              getter: (ChatBook o) => o.author.replaceAll(RegExp(r";"), " "),
              weight: 0)
        ]));

    tagWhitelist = tagWhitelist.toSet().toList();
    authorWhiteList = authorWhiteList.toSet().toList();
  }
}
