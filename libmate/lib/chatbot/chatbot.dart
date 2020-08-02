import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/utils/utils.dart';

String readUser() {
  return stdin.readLineSync();
}

class ChatBook {
  String name, author;
  String tag, isbn, description;

  ChatBook({this.name, this.author, this.tag, this.isbn, this.description});

  ChatBook.fromJSON(Map<String, dynamic> json) {
    this.name = json["name"] ?? json["title"];
    this.author = json["author"] ?? json["authors"] ?? "";
    this.isbn = json['isbn'] is String ? json['isbn'] : json['isbn'].toString();
    this.author = json["author"] ?? (json["authors"] ?? "");
    this.isbn =
        (json["isbn"] is String ? json["isbn"] : json["isbn"].toString());

    this.description = json["description"];
  }
}

class Chatbot {
  List<String> recActions = ["recommend", "suggest", "give", "tell"];
  List<String> tagPrec = ["on"];
  List<String> authPrec = ["by"];
  List<String> descrActions = ["describe", "description"];
  List<String> issueActions = ["issue"];
  List<String> greetings = ["hello", "hi", "hey", "yo"];

  List<ChatBook> books;
  Map<String, int> mapper;

  int context;

  Chatbot() {
    context = 0;
  }

  List<String> extractStuff(List<String> prec, String userInput) {
    List<String> author = [];
    for (var token in prec) {
      var reg = RegExp(token + r" (\w+)", caseSensitive: false);
      print("$reg $userInput");
      var matches = reg.allMatches(userInput);
      for (var match in matches) {
        author.add(match.group(1));
      }
    }
    return author.toSet().toList();
  }

  List<String> extractAuthor(String userInput) {
    return extractStuff(authPrec, userInput);
  }

  List<String> extractTag(String userInput) {
    return extractStuff(tagPrec, userInput);
  }

  bool checkExists(List<String> triggers, String str) {
    for (var trigger in triggers) {
      if (new RegExp(trigger, caseSensitive: false).hasMatch(str)) return true;
    }
    return false;
  }

  bool sanityCheck(String userInput) {
    return checkExists(recActions, userInput);
  }

  bool helloCheck(String userInput) {
    return checkExists(greetings, userInput);
  }

  Future<List<ChatBook>> search(
      List<String> author, List<String> subject) async {
    Map<String, String> query = {"maxResults": "3"};
    if (author != null) query["author"] = author[0];
    if (subject != null) query["tag"] = subject[0];

    print("Searching");
    print(author);
    print(subject);
    print(query);
    Uri url = Uri.http("54.83.31.83", "/query", query);
    final result = await http.get(url); // call api;
    if (result.statusCode != 200) {
      print('ERROR: Search did not return a 200 Server response code');
      return [];
    }
    // Process the response
    var response = readBookData(result);

    List<ChatBook> res = List();
    for (var x in response) res.add(ChatBook.fromJSON(x));

    return res;
  }

  // context = 0 => greeting, ask for book recommendation
  // context = 1 => book recommendation shown

  dynamic giveInput(String userInput) async {
    bool hello = helloCheck(userInput);

    if (context == 0 && !sanityCheck(userInput)) {
      return [
        hello ? "Hi there!" : "Sorry I do not understand that.",
        "Try asking me to 'recommend a maths book' or 'give a good book by michael nielsen about quantum physics'"
      ];
    }

    List<String> output = [];
    if (hello) output.add("Hey there!");

    var detectedSubjects = extractTag(userInput);
    var detectedAuthors = extractAuthor(userInput);

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

    for (int i = 0; i < db['id'].length; i++) {
      var idx = i.toString();
      var author = db['author'][idx];
      var name = db['title'][idx];
      var isb = db['isbn'][idx];
      var desc = db['description'][idx];
      var tag = db['tag'][idx];
      if (name == null || author == null || isb == null || desc == null)
        continue;

      var isbn = isb.toInt().toString();
      var entry = ChatBook(
          name: name, author: author, description: desc, tag: tag, isbn: isbn);
      mapper[isbn] = books.length;
      books.add(entry);
    }
  }
}
