import 'dart:io';

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
    actionRegex = new RegExp(actions.join("|"));
  }

  void extractSubject() {}

  void giveInput(String userInput) {
    var match = actionRegex.allMatches(userInput);

    if (match.length == 0) {
      output("Bad input");
      return;
    }

    var tokens = userInput.split(" ");

    for (var token in tokens) {}
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
    String input = readUser();

    bot.giveInput(input);
  }
}
