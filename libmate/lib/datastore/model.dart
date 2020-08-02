import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:libmate/datastore/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Basic Features of the user
  String uid, name, email, photoUrl, role;
  List<BookModel> starList = [];
  List<BorrowBookModel> borrowedBooks = [];
  List<BorrowBookModel> pastBooks = [];

  UserModel({
    this.name,
    this.email,
    this.photoUrl,
    this.uid,
    this.role = "student",
  });

  void loginUser(UserModel userData) {
    this.name = userData.name;
    this.email = userData.email;
    this.photoUrl = userData.photoUrl;
    this.uid = userData.uid;

    // this.name = "Akshat";
    // this.email = "akshatgoyalak23@gmail.com";
    // this.photoUrl =
    //     "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";
    // this.uid = "20102010";

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

  static const String LOGGED_IN = "logged_in";
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

    // if (true) {
    //   model.name = "Akshat";
    //   model.email = "akshatgoyalak23@gmail.com";
    //   model.photoUrl =
    //       "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";
    //   model.uid = "20102010";
    // }

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

const String defImage =
    "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg";

class BookModel {
  // Basic book identifiers
  String name;
  String author;
  String isbn;
  String image;
  String subject;
  String genre;
  String description;
  Map<String, dynamic> issues = Map<String, dynamic>();

  BookModel(
      {@required this.name,
      this.author = "",
      this.isbn = "",
      this.image =
          "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg",
      this.subject = "",
      this.genre = "",
      this.description});

  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;

  BookModel.fromJSON({Map<String, dynamic> json, String isbn}) {
    this.name = json["name"] ?? json["title"];
    this.author = json["author"] ?? (json["authors"] ?? "");
    this.genre = json["genre"] ?? (json["category"] ?? "");
    // isbn parameter is highest priority, don't remove
    this.isbn = isbn ??
        (json["isbn"] is String ? json["isbn"] : json["isbn"].toString());
    this.image = json["image"] ?? defImage;
    var jstheir = json["issues"];

    if (jstheir != null) {
      var js = new Map<String, dynamic>.from(jstheir);
      this.issues = js;
    } else
      this.issues = Map<String, dynamic>();

    this.subject = json["subject"] ?? json["category"] ?? "";
    this.description = json["description"];
  }

  BookModel.fromSaved(Map json) {
    this.name = json["name"];
    this.author = json["author"];
    this.image = json["image"];
    this.issues = Map();
    this.subject = json["category"];
    this.description = json["description"];
  }
  toJSON() {
    return {
      "name": name,
      "author": author,
      "isbn": isbn,
      "image": image,
      "subject": subject,
      "genre": genre,
      "description": description
    };
  }
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

class BorrowBookModel {
  String accessionNumber;
  DateTime borrowDate, returnDate;
  BookModel book;
  static const int fineRate = 2;

  BorrowBookModel(
      {@required this.accessionNumber,
      this.borrowDate,
      @required this.book,
      this.returnDate}) {
    this.borrowDate = this.borrowDate ?? DateTime.now();
    assert(this.book.isbn != null);
    assert(this.book != null);
  }

  get dueDate {
    return borrowDate.add(Duration(days: 14));
  }

  get fine {
    int delay = DateTime.now().difference(this.borrowDate).inDays - 14;
    return (delay > 0 ? delay : 0) * fineRate;
  }

  BorrowBookModel.fromJSON(Map<dynamic, dynamic> json) {
    accessionNumber = json["accNo"];
    if (json["borrowDate"] != null)
      borrowDate = (json["borrowDate"]).toDate();
    else
      borrowDate = DateTime.now();
    if (json["returnDate"] is DateTime)
      returnDate = json["returnDate"];
    else if (json["returnDate"] is Timestamp)
      returnDate = json["returnDate"].toDate();
    book = cachedBooks[json["book"]];
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "accNo": accessionNumber,
      "borrowDate": borrowDate,
      "returnDate": returnDate,
      "book": book.isbn,
    };
  }

  bool isReturned() {
    return returnDate != null;
  }
}

class JournalModel {
  // Basic book identifiers
  String name;
  String image;
  String title;
  String impactfactor;
  String chiefeditor;
  String date;
  String volume;
  String issue;
  String description;
  String issn;

  JournalModel(
      {@required this.name,
      this.image =
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdejapong.com%2Fmaking-cover-art-for-nature%2F&psig=AOvVaw14M72qqXN5MBdAG-D5VkK1&ust=1596199113845000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCB3Kn_9OoCFQAAAAAdAAAAABAD",
      this.title = "",
      this.impactfactor = "",
      this.chiefeditor = "",
      this.date = "",
      this.volume = "",
      this.issue = "",
      this.description = "",
      this.issn = ""});

  JournalModel.fromJSON(Map<String, dynamic> json) {
    name = json["title"];
    title = json["topic"] ?? "";
    impactfactor = json["impactfactor"] ?? "";
    chiefeditor = (json["chiefeditor"] ?? "");
    date = (json["chiefeditor"] ?? "");
    volume = (json["volume"] ?? "").toString();
    issue = (json["issue"] ?? "").toString();
    description = (json["description"] ?? "");
    issn = (json["issn"] ?? "");
    image = json["image"] ??
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fdejapong.com%2Fmaking-cover-art-for-nature%2F&psig=AOvVaw14M72qqXN5MBdAG-D5VkK1&ust=1596199113845000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCB3Kn_9OoCFQAAAAAdAAAAABAD";
  }
}
