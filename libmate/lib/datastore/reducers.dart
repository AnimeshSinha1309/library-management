import 'package:libmate/datastore/actions.dart';
import 'package:libmate/datastore/model.dart';

AppState appStateReducer(AppState state, action) {
  if (action is LogInAction) {
    return state;
  } else if (action is SearchBooksAction) {
    return state;
  } else {
    return state;
  }
}
