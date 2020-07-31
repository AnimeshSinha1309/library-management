import 'dart:io';
import 'package:fuzzy/fuzzy.dart';

void output(dynamic msg) {
  print(msg);
}

String readUser() {
  return stdin.readLineSync();
}

class Chatbot {
  dynamic subjectsFuse;
  dynamic authorsFuse;
  List<String> actions = ["recommend", "suggest", "give"];
  RegExp actionRegex;

  Chatbot({subjects, authors}) {
    subjectsFuse = Fuzzy(subjects);
    authorsFuse = Fuzzy(authors);

    actionRegex = RegExp(actions.join("|"));
  }

  List<String> extractData(dynamic dataFuse, List<String> strTokens) {
    final int maxReturns = 5;

    List<String> detected;

    var distinctTokens = strTokens.toSet().toList();
    Map<String, double> scores = Map();

    for (var token in strTokens) {
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

    // for (var item in data) {
    //   var regexInput = item.toLowerCase().split(" ").join("|");
    //   var score = new RegExp(item).allMatches(str).length;
    //   if (score > 0) {
    //     detected.add(item);
    //   }
    // }
    // return detected;
  }

  void giveInput(String userInput) {
    var match = actionRegex.allMatches(userInput);

    if (match.isEmpty) {
      output("Bad input");
      return;
    }

    var tokens = userInput.split(" ");
    List<String> detectedSubjects = extractData(subjectsFuse, tokens);
    List<String> detectedAuthors = extractData(authorsFuse, tokens);
    print(detectedAuthors);
    print(detectedSubjects);
  }
}

void main() {
  output("Welcome to the chatbot");
  output("You can ask me to recommend/suggest/give you a book");

  var subjects = ["math"];
  var authors = ["Enid Blyton"];
  Chatbot bot = new Chatbot(subjects: subjects, authors: authors);

  // game loop
  while (true) {
    var input = readUser();

    bot.giveInput(input);
  }
}
