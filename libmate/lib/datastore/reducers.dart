import 'package:google_sign_in/google_sign_in.dart';
import 'package:libmate/datastore/actions.dart';
import 'package:libmate/datastore/model.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

AppState appStateReducer(AppState state, action) {
  if ((action is LogInAction) || (action is AddUserTagAction)
      || (action is RemoveUserTagAction)) {
    return AppState(
      user: userModelReducer(state.user, action),
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
  if (action is AddUserTagAction) {
    state.likedTags.add(action.tag);
  } else if (action is RemoveUserTagAction) {
    state.likedTags.removeAt(action.index);
  }
  return action.userModel;
}