class ToRead {
  String book;
  String date;

  ToRead({String book, String date}) {
    this.book = book;
    this.date = date;
  }

  ToRead.fromJson(Map<String, dynamic> json)
      : book = json['book'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'book': book,
        'date': date,
      };
}

ToRead booklist = ToRead(book: "Gulliver's Travels", date: "23/6");
