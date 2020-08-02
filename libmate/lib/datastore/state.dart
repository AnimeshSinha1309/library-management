import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libmate/datastore/model.dart';
import 'dart:async';

/// Global State of the User

Future<void> loadUser(UserModel currentUser) async {
  final user = await Firestore.instance
      .collection("users")
      .document(currentUser.uid)
      .get();
  if (!user.exists) {
    Firestore.instance
        .collection("users")
        .document(currentUser.uid)
        .setData({"issueList": [], "role": "student"});
  } else {
    currentUser.borrowedBooks = [];
    currentUser.pastBooks = [];
    for (var borrow in user.data["issueList"]) {
      var el = BorrowBookModel.fromJSON(borrow);
      if (el.returnDate == null)
        currentUser.borrowedBooks.add(el);
      else
        currentUser.pastBooks.add(el);
    }
    currentUser.role = user.data["role"];
  }
}

Future issueBookModel(BookModel model, UserModel user) {
  return issueBook(model.isbn, user);
}

Future issueBook(String isbn, UserModel currentUser,
    [String accNo = ""]) async {
  var data = await Firestore.instance.collection("books").document(isbn).get();
  BookModel book = BookModel.fromJSON(json: data.data, isbn: isbn);

  if (accNo == "") {
    for (var key in book.issues.keys) {
      if (book.issues[key] == "issued") continue;
      accNo = key;
      break;
    }
  }

  if (!book.issues.containsKey(accNo))
    throw Exception("Invalid Accession Number for given ISBN.");
  book.issues[accNo] = "issued";

  var borrow = BorrowBookModel(
      accessionNumber: accNo, borrowDate: DateTime.now(), book: book);
  Firestore.instance.collection("users").document(currentUser.uid).setData({
    'issueList': FieldValue.arrayUnion([borrow.toJSON()]),
  }, merge: true);
  Firestore.instance.collection("books").document(isbn).setData({
    'issues': book.issues,
  }, merge: true);
  await loadUser(currentUser);
  await currentUser.toSharedPrefs();
}

Future returnBook(String isbn, UserModel currentUser, String accNo) async {
  var data = await Firestore.instance.collection("books").document(isbn).get();
  BookModel book = BookModel.fromJSON(json: data.data, isbn: isbn);
  if (!book.issues.containsKey(accNo))
    throw Exception("Invalid Accession Number for given ISBN.");
  book.issues[accNo] = "available";

  var user = await Firestore.instance
      .collection("users")
      .document(currentUser.uid)
      .get();
  if (!user.exists)
    throw Exception("User with current UID was not found on FireStore");
  var issueList = user.data["issueList"];
  for (var item in issueList) {
    if (item["accNo"] == accNo) {
      item["returnDate"] = DateTime.now();
    }
  }
  Firestore.instance.collection("books").document(isbn).setData({
    'issues': book.issues,
  }, merge: true);
  Firestore.instance.collection("users").document(currentUser.uid).setData({
    'issueList': issueList,
  }, merge: true);

  await loadUser(currentUser);
  await currentUser.toSharedPrefs();
}

/// Adding new books to the library

Future createBook(String isbn, String title, String author, String description,
    int accNo) async {
  var currentBook =
      await Firestore.instance.collection("books").document(isbn).get();
  Map accList = Map();
  if (currentBook.exists) {
    accList = currentBook.data['accNo'];
    accList[accNo] = "available";
  } else {
    accList[accNo] = {accNo: "available"};
  }

  Firestore.instance.collection("books").document(isbn).setData({
    'name': title,
    'authors': author,
    'description': description,
    'accNo': accList,
  }, merge: true);
}

/// Cached Books for Search and Recommendations

Map<String, BookModel> cachedBooks;

void loadBooks(Function callback) {
  cachedBooks = Map<String, BookModel>();
  Firestore.instance.collection('books').getDocuments().then((snapshot) {
    final documents = snapshot.documents;
    for (var document in documents) {
      cachedBooks[document.documentID] =
          BookModel.fromJSON(json: document.data, isbn: document.documentID);
    }
  }).then((NULL) {
    // funny but true: without this NULL argment it does not work
    callback();
    return Future.value(true); // necessary compile-time
  });
}
