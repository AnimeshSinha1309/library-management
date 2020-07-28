import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  // Basic Features of the user
  String uid, name, email, photoUrl, role;
  List<BookModel> wishList;

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
        this.author = "",
        this.isbn = "",
        this.image =
        "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg",
        this.subject = "",
        this.genre = "",
        this.description});

  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;

  BookModel.fromJSON(Map<String, dynamic> json) {
    name = json["title"];
    author = json["author"] ?? "";
    genre = json["category"] ?? "";
    isbn = (json["isbn"] ?? "").toString();
    image = json["image"] ??
        "https://rmnetwork.org/newrmn/wp-content/uploads/2011/11/generic-book-cover.jpg";
  }
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

class BorrowBookModel {
  int accessionNumber;
  DateTime borrowDate;
  BookModel book;
  static const int fineRate = 2;

  BorrowBookModel(
      {@required this.accessionNumber, this.borrowDate, @required this.book}) {
    this.borrowDate = this.borrowDate ?? DateTime.now();
    assert(this.book != null);
  }

  get dueDate {
    return borrowDate.add(Duration(days: 14));
  }

  get fine {
    int delay = DateTime
        .now()
        .difference(this.borrowDate)
        .inDays - 14;
    return (delay > 0 ? delay : 0) * fineRate;
  }
}
