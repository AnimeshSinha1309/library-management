import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libmate/datastore/model.dart';
import 'package:libmate/datastore/state.dart';
import 'package:libmate/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

String readUser() {
  return stdin.readLineSync();
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

var commonTags = ["math", "quantum", "network", "physics"];
Map<String, String> correctSpell;

void genMispells() {
  correctSpell = Map();
  for (var tag in commonTags) {
    var orgTag = tag;
    for (int i = 0; i < orgTag.length; i++) {
      for (int c = 97; c <= 122; c++) {
        var newtag = orgTag.substring(0, i) +
            String.fromCharCode(c) +
            orgTag.substring(i + 1);
        correctSpell[newtag] = orgTag;
      }
    }
  }
}

const String defImage =
    "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg";

class ChatBook {
  String name, author;
  String tag, isbn, description;
  String image;

  ChatBook({this.name, this.author, this.tag, this.isbn, this.description});

  ChatBook.fromJSON(Map<String, dynamic> json) {
    this.name = json["name"] ?? json["title"];
    this.author = json["author"] ?? json["authors"] ?? "";
    this.isbn = json['isbn'] is String ? json['isbn'] : json['isbn'].toString();
    this.author = json["author"] ?? (json["authors"] ?? "");
    this.isbn =
        (json["isbn"] is String ? json["isbn"] : json["isbn"].toString());

    this.image = json["image"] ?? defImage;
    this.tag = json["tag"];
    this.description = json["description"];
  }

  toBookModel() {
    return BookModel(
        name: name,
        author: author,
        isbn: isbn,
        description: description,
        image: image);
  }

  toJSON() {
    return {
      "name": name,
      "author": author,
      "isbn": isbn,
      "genre": tag,
      "description": description
    };
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
    print(user.email);
    context = 0;
    currBooks = [];
    genMispells();
    print(correctSpell);
  }

  List<String> extractStuff(List<String> prec, String userInput) {
    List<String> author = [];
    for (var token in prec) {
      var reg = RegExp(r"\b" + token + r" (\w+)", caseSensitive: false);
      print("$reg $userInput");
      var matches = reg.allMatches(userInput);
      for (var match in matches) {
        var use = match.group(1);
        if (correctSpell.containsKey(use)) {
          author.add(correctSpell[use]);
        } else
          author.add(use);
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
      if (new RegExp(r"\b" + trigger + r"\b", caseSensitive: false)
          .hasMatch(str)) return true;
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
    Map<String, String> query = {"maxResults": "10"};
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
    int cnt = 0;
    final int MAX_BOOKS = 4;

    for (var x in response) {
      var bk = ChatBook.fromJSON(x);
      print(bk);

      if (bk.name == null ||
          bk.description == null ||
          bk.author == null ||
          bk.isbn == null) continue;
      res.add(bk);
      cnt++;
      if (cnt > MAX_BOOKS) break;
    }

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

    if (detectedAuthors.isEmpty && detectedSubjects.isEmpty) {
      output.add("Please give me the subject or author name");
    } else {
      var result = await search(aTokens, sTokens);
      currBooks = result;

      if (result.length == 0) {
        output
            .add("Sorry, I could not find any books related to that criteria");
      } else {
        for (var book in result) {
          output.add("Title: ${book.name} by ${book.author}");
        }
      }
      context = 1;
    }

    return output;
  }

  Future<int> saveCart(BookModel model) async {
    final int maxBooks = 4;
    final key = "issuecart";
    final prefs = await SharedPreferences.getInstance();
    List<String> issueCart = prefs.getStringList(key) ?? [];
    if (issueCart.length > maxBooks) return 1;

    String nBookName = model.name;
    for (var issued in issueCart) {
      var js = json.decode(issued);
      if (BookModel.fromJSON(json: js).name == nBookName) {
        return 3;
      }
    }

    issueCart.add(jsonEncode(model.toJSON()));

    return (await prefs.setStringList(key, issueCart)) ? 0 : 2;
  }

  Future<String> addBookCart(BookModel model) async {
    int res = await saveCart(model);
    if (res == 0) {
      return "Added to cart";
    } else if (res == 1) {
      return "Exceeded max size of cart";
    } else if (res == 2) {
      return "Error saving cart";
    } else if (res == 3) {
      return "Book already present";
    } else {
      return "Unknown Error";
    }
  }

  int getOrdinal(String str) {
    List<String> ordinals = ["first", "second", "third", "fourth", "fifth"];
    int i = 0;
    for (var ordinal in ordinals) {
      if (RegExp(ordinal, caseSensitive: false).hasMatch(str)) {
        return i;
      }
      i++;
    }
    List<String> pos = ["one", "two", "three", "four", "five"];
    i = 0;
    for (var ordinal in pos) {
      if (RegExp(ordinal, caseSensitive: false).hasMatch(str)) {
        return i;
      }
      i++;
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
      out.add(
          "Sorry I did not understand the book number to describe. Could you please tell me again?");
    }
    return out;
  }

  Future<List<String>> issue(String str) async {
    List<String> out = [];
    int ord = getOrdinal(str);

    if (ord != -1) {
      var book = currBooks[ord];
      String res = await addBookCart(book.toBookModel());
      out.add("Book ${book.name}: $res");
    } else {
      out.add(
          "Sorry I did not understand the book number to issue. Could you repeat?");
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
        out = await issue(userInput);
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
