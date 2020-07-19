import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Basic Features of the user
  String uid, name, email, photoUrl, role;

  UserModel({
    this.name,
    this.email,
    this.photoUrl,
    this.uid,
  }) {
    this.role = "student";
  }

  void loginUser(UserModel userData) {
    this.name = userData.name;
    this.email = userData.email;
    this.photoUrl = userData.photoUrl;
    this.uid = userData.uid;

    toSharedPrefs();
    notifyListeners();
  }

  void logoutUser() {
    uid = null;
    toSharedPrefs();
    notifyListeners();
  }

  bool isLoggedIn() {
    return uid != null;
  }

  static String LOGGED_IN = "logged_in";
  static List<String> props = [ "name", "email", "photoUrl", "uid"];

  static Future<UserModel> fromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    UserModel model = new UserModel();
    print(model.uid);

    if (prefs.getBool(LOGGED_IN) ?? false) {
      model.uid = prefs.getString("uid");
      model.name = prefs.getString("name");
      model.email = prefs.getString("email");
      model.photoUrl = prefs.getString("photoUrl");
    }

    return model;
  }

  void toSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", this.name);
    prefs.setString("email", this.email);
    prefs.setString("photoUrl", this.photoUrl);
    prefs.setString("uid", this.uid);
    prefs.setBool(LOGGED_IN, this.isLoggedIn());
  }
}
//// For the library card
//List<BorrowedBookModel> borrowed;
//
//// For the wish list and recommendations
//// TODO: these should NOT be models?
//List<BookModel> wishList;
//List<BookModel> pastReads;
//List<UserModel> friends;
//List<String> likedTags = <String>[];

class BookModel {
  // Basic book identifiers
  final String name;
  final String author;
  final int isbn;

  BookModel({@required this.name, this.author, this.isbn});

  // List of books in library
  // TODO: what is the String representing?
  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

class BorrowedBookModel extends BookModel {
  final String accessionNumber;
  final DateTime dueDate;

  BorrowedBookModel({this.accessionNumber, this.dueDate});
}

class BookList {
  List<BookModel> books;
}

class SearchResults extends BookList {
}

class RecommendedBooks extends BookList {
}
