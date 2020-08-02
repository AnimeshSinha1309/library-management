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

  List<String> extractTokens(dynamic dataFuse, List<String> strTokens) {
    var distinctTokens = strTokens.toSet().toList();
    final threshold = 0.01;
    List<String> tokens = [];

    for (var token in distinctTokens) {
      if (new RegExp(r"^\s*$").hasMatch(token)) continue;

      var res = dataFuse.search(token); // item, score relevant to us

      if (res[0].score < threshold) {
        print("((((");
        print(res[0].item.name);
        print(res[0].item.author);
        print(token);
        tokens.add(token);
      }
    }

    return tokens;
  }

  List<String> extractData(
      dynamic dataFuse, List<String> strTokens, List<String> whiteList,
      {Map<String, double> scores}) {
    double threshold = 0.01;
    var distinctTokens = strTokens.toSet().toList();
    if (scores == null) scores = Map();

    for (var token in distinctTokens) {
      if (new RegExp(r"^\s*$").hasMatch(token)) continue;
      var res = dataFuse.search(token); // item, score relevant to us

      for (var row in res) {
        var item = row.item;
        scores[item.isbn] = (scores[item.isbn] ?? 0) + row.score;
      }
    }

    var keysDesc = scores.keys.toList()
      ..sort((b, a) => scores[b].compareTo(scores[a]));

    int i = 0;
    print("==+++++== $strTokens");

    threshold += scores[keysDesc[0]];
    for (var item in keysDesc) {
      var book = books[mapper[item]];
      if (scores[item] > threshold) {
        print("${scores['item']}");
        break;
      }

      if (i < 10)
        print("${book.name} ${scores[item]} ${book.tag} ${book.author}");

      i++;
    }
    keysDesc = keysDesc.sublist(0, i);
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
      List<String> author, List<String> subject) async {
    final mxlen = 3;
    var res = [];
    if (subject != null) {
      res = extractData(subjectsFuse, subject, []);
    } else {
      res = extractData(authorsFuse, author, []);
      if (res.length > mxlen) {
        res = res.sublist(0, mxlen);
      }
    }

    res = res.map<ChatBook>((x) => books[mapper[x]]).toList();

    if (subject == null) return res;

    var fuse = Fuzzy(res,
        options: FuzzyOptions(keys: [
          WeightedKey(name: 'combo', getter: (x) => x.author, weight: 0)
        ]));
    var finalRes;
    if (author != null)
      finalRes = extractData(fuse, author, []);
    else
      finalRes = res;

    if (finalRes.length > mxlen) {
      finalRes = finalRes.sublist(0, mxlen);
    }

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

    List<String> output = [];
    if (hello) output.add("Hey there!");

    tokens = stopwordRemoval(tokens);

    var detectedSubjects = extractTokens(subjectsFuse, tokens);
    var detectedAuthors = extractTokens(authorsFuse, tokens);

    output.add("Recommending books based on");
    String author = "Author: ";
    String subjects = "Subject: ";

    List<String> aTokens, sTokens;

    if (detectedAuthors.isEmpty) {
      author += "none";
    } else {
      aTokens = detectedAuthors;
      author += detectedAuthors.join(" ");
    }

    if (detectedSubjects.isEmpty) {
      subjects += "none";
    } else {
      sTokens = detectedSubjects;
      subjects += detectedSubjects.join(" ");
    }

    output.add(author + "; " + subjects);

    var result = await search(aTokens, sTokens);

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
              getter: (ChatBook o) => o.author.replaceAll(RegExp(r";|,"), " "),
              weight: 0)
        ]));

    tagWhitelist = tagWhitelist.toSet().toList();
    authorWhiteList = authorWhiteList.toSet().toList();
  }
}
