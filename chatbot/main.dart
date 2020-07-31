import 'dart:io';
import 'package:fuzzy/fuzzy.dart';

void output(dynamic msg) {
  print(msg);
}

String readUser() {
  return stdin.readLineSync();
}

class Chatbot {
  List<String> subjects;
  List<String> authors;
  List<String> actions = ["recommend", "suggest", "give"];
  RegExp actionRegex;

  Chatbot({this.subjects, this.authors}) {
    actionRegex = RegExp(actions.join("|"));
  }

  List<String> extractData(List<String> data, String str) {
    List<String> detected;
    for (var item in data) {
      var regexInput = item.toLowerCase().split(" ").join("|");
      var score = new RegExp(item).allMatches(str).length;
      if (score > 0) {
        detected.add(item);
      }
    }
    return detected;
  }

  void giveInput(String userInput) {
    var match = actionRegex.allMatches(userInput);

    if (match.isEmpty) {
      output("Bad input");
      return;
    }

    var tokens = userInput.split(" ");
    List<String> detectedSubjects = extractData(subjects, userInput);
    List<String> detectedAuthors = extractData(authors, userInput);
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
