import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class LogInAction {}

class SearchBooksAction {
  String searchString;

  SearchBooksAction(this.searchString);
}
