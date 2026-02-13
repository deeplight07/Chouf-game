
class CategoryModel {
  final String id;
  final String name;
  final String iconPath;
  bool isLocked;
  final List<String> words;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.isLocked,
    required this.words,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      iconPath: json['iconPath'],
      isLocked: json['isLocked'] ?? false,
      words: List<String>.from(json['words']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'isLocked': isLocked,
      'words': words,
    };
  }
}
