import 'package:google_sign_in/google_sign_in.dart';
import 'package:libmate/datastore/actions.dart';
import 'package:libmate/datastore/model.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

AppState appStateReducer(AppState state, action) {
  if (action is LogInAction) {
    UserModel userModel = userModelReducer(state.user, action);
    return AppState(
      user: userModel,
      recommendedBooks: state.recommendedBooks,
      searchResults: state.searchResults,
    );
  } else if (action is SearchBooksAction) {
    return state;
  } else {
    return state;
  }
}

UserModel userModelReducer(UserModel state, action) {
  return action.userModel;
}