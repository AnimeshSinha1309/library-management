import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  // Basic Features of the user
  String uid, name, email, photoUrl;

  UserModel({
    @required this.name,
    @required this.email,
    this.photoUrl,
    this.uid
  });

  void loginUser(Object userData) {
    // TODO: extract user data out into our fields
    notifyListeners();
  }

  void logoutUser() {
    uid = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return uid != null;
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
