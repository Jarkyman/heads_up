class CategoryModel {
  final String category;
  final String iconUrl;
  final int colorHex;

  CategoryModel(
      {required this.category, required this.iconUrl, required this.colorHex});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'],
      iconUrl: json['iconUrl'],
      colorHex: int.parse(json['colorHex']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'iconUrl': iconUrl,
      'colorHex': colorHex.toString(),
    };
  }
}
