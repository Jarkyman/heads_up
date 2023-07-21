import 'package:get/get.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/models/category_model.dart';

class WordModel {
  WordModel({required this.word, required this.category});

  final String word;
  final List<CategoryModel> category;

  factory WordModel.fromJson(Map<String, dynamic> json) {
    var categoryNames = json['category'].cast<String>();
    List<CategoryModel> result = [];
    for (String categoryName in categoryNames) {
      for (CategoryModel category
          in Get.find<CategoryController>().categories) {
        if (category.category == categoryName) {
          result.add(category);
        }
      }
    }
    List<CategoryModel> categories = result;
    return WordModel(word: json['word'], category: categories);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = word;
    data['category'] = category.map((category) => category.category).toList();
    return data;
  }
}
