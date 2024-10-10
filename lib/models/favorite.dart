class Favorit {
  int id;
  int userid;
  int bookid;
  int isFavorite;

  Favorit({
    required this.id,
    required this.userid,
    required this.bookid,
    required this.isFavorite,
  });

  factory Favorit.fromMap(Map<String, dynamic> json) => Favorit(
        id: json["id"],
        userid: json["userid"],
        bookid: json["bookid"],
        isFavorite: json["isFavorite"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userid": userid,
        "bookid": bookid,
        "isFavorite": isFavorite,
      };
}
