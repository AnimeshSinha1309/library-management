class RequestedBookModel {
  String name;
  String isbn;
  String subject;
  String reason;
  int cnt;
  String image;

  RequestedBookModel(
      {this.isbn, this.name, this.subject, this.reason, this.cnt, this.image});
}
