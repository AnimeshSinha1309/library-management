import 'dart:io';
import 'package:fuzzy/fuzzy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String readUser() {
  return stdin.readLineSync();
}

class Chatbot {
  dynamic subjectsFuse;
  dynamic authorsFuse;
  List<String> actions = ["recommend", "suggest", "give"];
  dynamic actionFuse;

  Chatbot({subjects, authors}) {
    subjectsFuse = Fuzzy(subjects);
    authorsFuse = Fuzzy(authors);

    actionFuse = Fuzzy(actions);
  }

  List<String> extractData(dynamic dataFuse, List<String> strTokens) {
    final maxReturns = 3;

    var distinctTokens = strTokens.toSet().toList();
    Map<String, double> scores = Map();

    for (var token in distinctTokens) {
      var res = dataFuse.search(token); // item, score relevant to us
      for (var row in res) {
        var item = row.item;
        scores[item] = (scores[item] ?? 0) + row.score;
      }
    }

    var keysDesc = scores.keys.toList()
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    if (keysDesc.length > maxReturns) {
      keysDesc = keysDesc.sublist(0, maxReturns);
    }
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

  dynamic makeOneQuery(Map<String, String> query) async {
    query["maxResults"] = "1";
    Uri url = Uri.https("libmate.herokuapp.com", "/query", query);
    final result = await http.get(url); // call api;
    if (result.statusCode != 200) {
      print('ERROR: Search did not return a 200 Server response code');
      return;
    }
    return readBookData(result);
  }

  dynamic getData(String key, List<String> queries) async {
    List<dynamic> res = List();
    print("Queries");
    print(queries);

    for (var query in queries) {
      Map<String, String> obj = Map();
      obj[key] = query;

      var val = await makeOneQuery(obj);
      res.addAll(val);
    }
    return res;
  }

  dynamic search(List<String> authors, List<String> subjects) async {
    List<dynamic> finalRes = List();

    var res1 = await getData("author", authors);
    var res2 = await getData("category", subjects);
    finalRes.addAll(res1);
    finalRes.addAll(res2);
    return finalRes;
  }

  dynamic giveInput(String userInput) async {
    var tokens = userInput.split(" ");

    if (!sanityCheck(tokens)) {
      return [
        "Sorry I do not understand that.",
        "Try asking me to 'recommend a maths book' or 'give a good book by michael nielsen about quantum physics'"
      ];
    }

    var detectedSubjects = extractData(subjectsFuse, tokens);
    var detectedAuthors = extractData(authorsFuse, tokens);
    print(detectedAuthors);
    print(detectedSubjects);

    var result = await search(detectedAuthors, detectedSubjects);

    return [result];
  }

  dynamic getWelcome() {
    return [
      "Welcome to the chatbot",
      "You can ask me to recommend/suggest/give you a book"
    ];
  }
}
