import 'package:libmate/datastore/model.dart';

class LogInAction {
  UserModel userModel;
  LogInAction(this.userModel);
}

class SearchBooksAction {
  String searchString;
  SearchBooksAction(this.searchString);
}

class AddUserTagAction {
  String tag;

  AddUserTagAction(this.tag);
}

class RemoveUserTagAction {
  int index;

  RemoveUserTagAction(this.index);
}
