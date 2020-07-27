const String def = "Not Specified";
const String defImage =
    "http://assets.stickpng.com/images/5847f289cef1014c0b5e486b.png";

class RequestBookModel {
  String name;
  String isbn;
  String subject;
  String reason;

  RequestBookModel({this.name, this.isbn, this.subject, reason}) {
    this.reason = reason ?? def;
  }
}

class RequestedBookModel extends RequestBookModel {
  String uid;
  int count;
  String image;

  RequestedBookModel({this.uid, name, isbn, subject, reason, count, image}): super(name: name, isbn: isbn, subject: subject, reason: reason) {
    this.count = count ?? 1;
    this.image = image ?? defImage;
  }
}

RequestBookModel booklist = RequestBookModel(name: "Gulliver's Travels", isbn: "9781982654368", subject: "Fiction");
