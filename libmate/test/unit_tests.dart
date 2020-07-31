import 'package:flutter_test/flutter_test.dart';
import 'package:libmate/views/goals.dart';
import 'package:libmate/views/accounts.dart';
import 'package:libmate/widgets/toread.dart';

void main() {
  group('Goals', () {
    test('Initially should be zero', () {
      final goals = GoalsPage();

      expect(goals.createState().numBooks, 0);
    });
    // test('Adding', () {
    //   final goals = GoalsPage().createState();
    //   goals.addBook(ToRead(book: "New Book 1", date: "28/7"));
    //   goals.addBook(ToRead(book: "New Book 2", date: "28/8"));
    //   expect(goals.numBooks, 2);
    // });
    // test('Removal', () {
    //   final goals = GoalsPage().createState();
    //   goals.addBook(ToRead(book: "New Book 1", date: "28/7"));
    //   goals.addBook(ToRead(book: "New Book 2", date: "28/8"));
    //   goals.removeBook(ToRead(book: "New Book 2", date: "28/8"));
    //   expect(goals.numBooks, 1);
    // });
  });
  group("Accounts", () {
    test("Not logged in", () {
      final account = AccountsPage();
      expect(account.createState().loggedIn, null);
    });
  });
}
