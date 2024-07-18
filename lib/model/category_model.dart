class Category {
  int? id; // id can be null for new categories
  String title;
  String description;
  String colorName;

  Category({
    this.id,
    required this.title,
    required this.description,
    required this.colorName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'colorName': colorName,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      colorName: map['colorName'],
    );
  }
}
