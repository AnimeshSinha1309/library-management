import 'package:flutter/foundation.dart';

class UserModel {
  // Basic Features of the user
  final String uid;
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
    this.uid,
    @required this.name,
    @required this.email,
    this.photoUrl,
    this.birthYear,
    this.borrowed,
    this.wishList,
    this.pastReads,
    this.friends,
  });

  static UserModel fromJson(dynamic json) =>
      UserModel(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        photoUrl: json["photoUrl"],
        birthYear: json["birthYear"],
        borrowed: json["borrowed"].map((x) => fromJson(x)).toList(),
        wishList: json["wishList"].map((x) => fromJson(x)).toList(),
        pastReads: json["pastReads"].map((x) => fromJson(x)).toList(),
        friends: json["friends"].map((x) => fromJson(x)).toList(),
      );

  dynamic toJson() =>
      {
        "uid": uid,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "birthYear": birthYear,
        "borrowed": borrowed.map((x) => x.toJson()).toList(),
        "wishList": wishList.map((x) => x.toJson()).toList(),
        "pastReads": pastReads.map((x) => x.toJson()).toList(),
        "friends": friends.map((x) => x.toJson()).toList(),
      };
}

class BookModel {
  // Basic book identifiers
  final String name;
  final String author;
  final int isbn;

  // List of books in library
  Map<String, BookModelBorrowState> copies;
  int issueCount, starCount;

  BookModel({@required this.name, this.author, this.isbn});

  static BookModel fromJson(dynamic json) {
    return BookModel(
      name: json["name"],
      author: json["author"],
      isbn: json["isbn"],
    );
  }

  dynamic toJson() =>
      {
        "name": name,
        "author": author,
        "isbn": isbn,
      };
}

enum BookModelBorrowState { BORROWED, RESERVED, AVAILABLE }

class BorrowedBookModel {
  final String accNo;
  final DateTime dueDate;
  final BookModel bookISBN;

  BorrowedBookModel({@required this.accNo, this.dueDate, this.bookISBN});

  static BorrowedBookModel fromJson(dynamic json) =>
      BorrowedBookModel(
        accNo: json["accNo"],
        dueDate: json["dueDate"],
        bookISBN: json["bookISBN"],
      );

  dynamic toJson() =>
      {
        "accNo": accNo,
        "dueDate": dueDate,
        "bookISBN": bookISBN,
      };
}

// Now moving to the overarching state of the app

class AppState {
  UserModel user;

  List<BookModel> recommendedBooks;
  List<BookModel> searchResults;

  AppState({this.user, this.recommendedBooks, this.searchResults});

  AppState.initialState() : user = UserModel(name: '', email: '');

  static AppState fromJson(dynamic json) =>
      AppState(
        user: json["accNo"],
        recommendedBooks: json["recommended"].map((x) => fromJson(x)).toList(),
        searchResults: json["search"].map((x) => fromJson(x)).toList(),
      );

  dynamic toJson() =>
      {
        "user": user.toJson(),
        "recommended": recommendedBooks.map((x) => x.toJson()).toList(),
        "search": searchResults.map((x) => x.toJson()).toList(),
      };
}
