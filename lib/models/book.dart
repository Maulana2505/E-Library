class Book {
  final int? id;
  int idauthors;
  String title;
  String image;
  String description;
  String filePath;

  Book({
    this.id,
    required this.idauthors,
    required this.title,
    required this.image,
    required this.description,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idauthors': idauthors,
      'title': title,
      'image': image,
      'description': description,
      'filePath': filePath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      idauthors: map['idauthors'],
      title: map['title'],
      image: map['image'],
      description: map['description'],
      filePath: map['filePath'],
    );
  }
}
