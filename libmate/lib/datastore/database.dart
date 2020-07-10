import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService(this.collection);

  final databaseReference = Firestore.instance;
  String collection;

  void createRecord() async {
    await databaseReference.collection(this.collection).document("1").setData({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref =
        await databaseReference.collection(this.collection).add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }

  void getData() {
    print("Getting Data");
    databaseReference
        .collection(this.collection)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void updateData() {
    try {
      databaseReference
          .collection(this.collection)
          .document('1')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData() {
    try {
      databaseReference.collection('users').document('1').delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
