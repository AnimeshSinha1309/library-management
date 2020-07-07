import 'package:flutter/foundation.dart';

class UserModel {
  // Basic Features of the user
  final String name;
  final String email;
  final String photoUrl;

  // Other MetaData
  final int birthYear;

  // For the library card
  List<BorrowedBookModel> borrowed;

  // For the wish list and recommendations
  List<BookModel> wishList;
  List<BookModel> pastReads;
  List<UserModel> friends;

  UserModel({
    @required this.name,
    @required this.email,
    this.photoUrl,
    this.birthYear
  });
}

class BookModel {
  // Basic book identifiers
  final String name;
  final String author;
  final int isbn;

  BookModel({@required this.name, this.author, this.isbn});

  // List of books in library
  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

class BorrowedBookModel extends BookModel {
  final String accessionNumber;
  final DateTime dueDate;

  BorrowedBookModel({this.accessionNumber, this.dueDate});
}

// Now moving to the overarching state of the app

class AppState {
  UserModel user;

  List<BookModel> recommendedBooks;
  List<BookModel> searchResults;

  AppState.initialState()
      : user = UserModel(name: 'Jesse Doe', email: 'test@test.iiit.ac.in');
}
