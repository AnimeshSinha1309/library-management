import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/state.dart';
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
  UserModel user;
  List<String> recActions = ["recommend", "suggest", "give", "tell"];
  List<String> tagPrec = ["on"];
  List<String> authPrec = ["by"];
  List<String> descrActions = ["describe", "description"];
  List<String> issueActions = ["issue"];
  List<String> greetings = ["hello", "hi", "hey", "yo"];

  List<ChatBook> books;
  Map<String, int> mapper;

  int context;
  List<ChatBook> currBooks;

  Chatbot(this.user) {
    context = 0;
    currBooks = [];
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

  bool descriptionCheck(String userInput) {
    return checkExists(descrActions, userInput);
  }

  bool issueCheck(String userInput) {
    return checkExists(issueActions, userInput);
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

  Future<List<String>> recommender(String userInput) async {
    List<String> output = [];
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
    currBooks = result;

    if (result.length == 0) {
      output.add("Sorry, I could not find any books related to that criteria");
    } else {
      for (var book in result) {
        output.add("Title: ${book.name} by ${book.author}");
      }
    }

    return output;
  }

  int getOrdinal(String str) {
    List<String> ordinals = ["first", "second", "third", "fourth", "fifth"];
    int i = 0;
    for (var ordinal in ordinals) {
      if (RegExp(ordinal, caseSensitive: false).hasMatch(str)) {
        return i;
      }
    }
    return -1;
  }

  List<String> description(String str) {
    List<String> out = [];
    int ord = getOrdinal(str);
    if (ord != -1) {
      out.add("Book ${currBooks[ord].name}");
      out.add(currBooks[ord].description);
    } else {
      out.add("Sorry I did not understand the book number");
    }
    return out;
  }

  Future<List<String>> issue(String str) async {
    List<String> out = [];
    int ord = getOrdinal(str);
    if (ord != -1) {
      await issueBook(currBooks[ord].isbn, user);
      out.add("Book ${currBooks[ord].name} added to cart");
    } else {
      out.add("Sorry I did not understand the book number");
    }
    return out;
  }

  dynamic giveInput(String userInput) async {
    bool hello = helloCheck(userInput);
    String err = "";
    List<String> out;

    bool recch = sanityCheck(userInput);
    bool desch = descriptionCheck(userInput);
    bool issch = issueCheck(userInput);

    if (context == 0 && !recch) {
      err =
          "Try asking me to 'recommend a book on math' or 'give a good book by michael nielsen on quantum physics'";
    } else if (context == 1 && !desch) {
      if (!issch) {
        if (!recch) {
          err =
              "Try asking me to describe the third book or issue the first book, or just another recommendation";
        } else {
          context = 0;
          out = await recommender(userInput);
        }
      } else {
        await issue(userInput);
      }
    } else if (context == 0) {
      out = await recommender(userInput);
    } else if (context == 1) {
      out = description(userInput);
    }

    if (err.length > 0) {
      String firstMsg = hello ? "Hi there!" : "Sorry I do not understand that.";
      return [firstMsg, err];
    }

    List<String> output = [];
    if (hello) output.add("Hey there!");

    output.addAll(out);
    return output;
  }

  dynamic getWelcome() {
    return [
      "Welcome to the chatbot",
      "You can ask me to recommend/suggest/give you a book"
    ];
  }
}
