const String def = "NaN";
const String defImage =
    "https://www.peterharrington.co.uk/blog/wp-content/uploads/2014/09/shelves.jpg";

class RequestBookModel {
  String name;
  String isbn;
  String subject;
  String reason;

  RequestBookModel({this.name, this.isbn, this.subject, reason}) {
    this.reason = reason ?? def;
  }

  Map<String, String> toMap() => {
        'title': name,
        'isbn': isbn,
        'category': subject,
        'reason': reason,
      };
}

class RequestedBookModel extends RequestBookModel {
  int count;
  String image;

  RequestedBookModel({name, isbn, subject, reason, count, image})
      : super(name: name, isbn: isbn, subject: subject, reason: reason) {
    this.count = count ?? 1;
    this.image = image ?? defImage;
  }

  factory RequestedBookModel.fromJson(Map<String, dynamic> json) {
    if(json['reason'] == def) json['reason'] = "Not Specified";
    if(json['image'] == def) json['image'] = defImage;
    return RequestedBookModel(
      name: json['title'],
      isbn: json['isbn'].toString(),
      subject: json['category'],
      reason: json['reason'],
      count: json['cnt'],
      image: json['image'],
    );
  }

  Map<String, String> toMap() => {
        'isbn': isbn,
      };
}

RequestBookModel booklist = RequestBookModel(
    name: "Gulliver's Travels", isbn: "9781982654368", subject: "Fiction");
