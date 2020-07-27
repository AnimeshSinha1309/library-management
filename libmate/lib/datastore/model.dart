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
    // this.name = userData.name;
    // this.email = userData.email;
    // this.photoUrl = userData.photoUrl;
    // this.uid = userData.uid;

    this.name = "Akshat";
    this.email = "akshatgoyalak23@gmail.com";
    this.photoUrl =
        "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";
    this.uid = "20102010";

    toSharedPrefs();
    notifyListeners();
  }

  void logoutUser() {
    uid = null;
    toSharedPrefs();
    notifyListeners();
  }

  bool isLoggedIn() {
    // return uid != null;
    return true;
  }

  void addReadingList(BookModel book) {}

  static const String LOGGED_IN = "logged_in";
  static List<String> props = ["name", "email", "photoUrl", "uid"];

  static Future<UserModel> fromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    UserModel model = new UserModel();

    // if (prefs.getBool(LOGGED_IN) ?? false) {
    //   model.uid = prefs.getString("uid");
    //   model.name = prefs.getString("name");
    //   model.email = prefs.getString("email");
    //   model.photoUrl = prefs.getString("photoUrl");
    // }

    if (true) {
      model.name = "Akshat";
      model.email = "akshatgoyalak23@gmail.com";
      model.photoUrl =
          "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";
      model.uid = "20102010";
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
  String name;
  String author;
  String isbn;
  String image;
  String subject;
  String genre;
  String description;

  BookModel(
      {@required this.name,
      this.author = def,
      this.isbn = def,
      this.image,
      this.subject = def,
        this.genre = def,
        this.description}) {
    this.image = this.image ?? defImage;
  }

  // List of books in library
  // TODO: what is the String representing?
  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;

  BookModel.fromJSON(Map<String, dynamic> json) {
    name = json["title"];
    author = json["author"] ?? def;
    genre = json["category"] ?? def;
    isbn = (json["isbn"] ?? def).toString();
    image = json["image"] ?? defImage;
  }
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

final defBorrow = DateTime.parse('2020-07-10');
final defDue = DateTime.parse('2020-07-20');
const defFine = 2.0;

class BorrowBookModel extends BookModel {
  String accessionNumber;
  DateTime borrowDate;
  DateTime dueDate;
  double fine;

  BorrowBookModel(
      {@required name,
      author,
      isbn,
      image,
      subject,
      genre,
      this.accessionNumber = def,
      borrowDate,
      dueDate,
      this.fine = defFine})
      : super(name: name, author: author, image: image, subject: subject) {
    // reference: https://stackoverflow.com/questions/15394313
    this.borrowDate = borrowDate ?? defBorrow;
    this.dueDate = dueDate ?? defDue;
  }
}

class BookList {
  List<BookModel> books;
}

class SearchResults extends BookList {}

class RecommendedBooks extends BookList {}
