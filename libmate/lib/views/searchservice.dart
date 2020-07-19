import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {

  searchByName(String searchField) {
    return Firestore.instance
        .collection('users')
        .where('username',
        isEqualTo: searchField)
        .getDocuments();
  }
}