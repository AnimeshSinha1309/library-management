import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:libmate/datastore/dummy.dart';
import 'package:libmate/datastore/model.dart';

/// Global State of the User

UserModel currentUser;
List<BorrowBookModel> borrowedBooks = dummyBorrow;

void loadUser(String uid) async {
  final user = await Firestore.instance.collection("users").document(uid).get();
  if (!user.exists) {
    Firestore.instance
        .collection("users")
        .document(uid)
        .setData({"issueList": [], "role": "student"});
  } else {
    borrowedBooks = user.data["issueList"];
    currentUser.role = user.data["role"];
  }
}

Future issueBook(String isbn, String uid, int accNo) async {
  BookModel book = BookModel.fromJSON(
      (await Firestore.instance.collection("books").document(isbn).get()).data);
  if (!book.issues.containsKey(accNo))
    throw Exception("Invalid Accession Number for given ISBN.");
  book.issues[accNo] = "issued";

  var borrow = BorrowBookModel(
      accessionNumber: accNo, borrowDate: DateTime.now(), book: book);
  Firestore.instance.collection("users").document(uid).setData({
    'issueList': FieldValue.arrayUnion([borrow.toJSON()]),
  }, merge: true);
  Firestore.instance.collection("books").document(isbn).setData({
    'state': book.issues,
  }, merge: true);
  borrowedBooks.add(borrow);
}

Future returnBook(String isbn, String uid, int accNo) async {
  BookModel book = BookModel.fromJSON(
      (await Firestore.instance.collection("books").document(isbn).get()).data);
  if (!book.issues.containsKey(accNo))
    throw Exception("Invalid Accession Number for given ISBN.");
  book.issues[accNo] = "available";

  var borrow = BorrowBookModel(
      accessionNumber: accNo, borrowDate: DateTime.now(), book: book);
  Firestore.instance.collection("users").document(uid).setData({
    'issueList': FieldValue.arrayRemove([borrow.toJSON()]),
  }, merge: true);
  Firestore.instance.collection("books").document(isbn).setData({
    'state': book.issues,
  }, merge: true);
  borrowedBooks.add(borrow);
}

/// Adding new books to the library

Future createBook(String isbn, String title, String author, String description,
    int accNo) async {
  Firestore.instance.collection("books").document(isbn).setData({
    'name': title,
    'authors': author,
    'description': description,
    'accNo': {accNo: "available"},
  }, merge: true);
}

/// Cached Books for Search and Recommendations

List<BookModel> cachedBooks = dummyBooks;

void loadBooks() {
  Firestore.instance.collection('books').getDocuments().then((snapshot) {
    final documents = snapshot.documents;
    cachedBooks = List<BookModel>();

    for (var document in documents) {
      final name = document.data["name"];
      cachedBooks.add(BookModel(name: name));
    }
  }).then((res) {
    final wk = WeightedKey(name: "keyer", getter: (obj) => obj.name, weight: 1);
    final fo = FuzzyOptions(keys: [wk]);
    var fuse = Fuzzy(cachedBooks, options: fo);
    // in fuse.search, score of 0 is full-match, 1 is complete mismatch
  });
}
