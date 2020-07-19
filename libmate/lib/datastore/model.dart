import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Basic Features of the user
  String uid, name, email, photoUrl, role;
  List<BookModel> wishList;

//// For the library card
//List<BorrowedBookModel> borrowed;
//
//// For the wish list and recommendations
//// TODO: these should NOT be models?
//List<BookModel> pastReads;
//List<UserModel> friends;
//List<String> likedTags = <String>[];

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

  void addReadingList(BookModel book) {}

  static String LOGGED_IN = "logged_in";
  static List<String> props = ["name", "email", "photoUrl", "uid"];

  static Future<UserModel> fromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    UserModel model = new UserModel();

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

const String def = "not found";
const String defImage =
    "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";

class BookModel {
  // Basic book identifiers
  final String name;
  String author;
  String isbn;
  String image;
  String subject;
  String genre;

  BookModel(
      {@required this.name,
      this.author = def,
      this.isbn = def,
      this.image = defImage,
      this.subject = def,
      this.genre = def});

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

class SearchResults extends BookList {}

class RecommendedBooks extends BookList {}
