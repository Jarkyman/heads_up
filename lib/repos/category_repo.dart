import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/app_constants.dart';
import '../models/category_model.dart';

class CategoryRepo {
  final SharedPreferences sharedPreferences;

  CategoryRepo({required this.sharedPreferences});

  Future<List<CategoryModel>> getCategories() async {
    return _getCategoriesFromName('categories');
  }

  Future<List<CategoryModel>> getEventCategories() async {
    return _getCategoriesFromName('eventCategories');
  }

  Future<List<CategoryModel>> _getCategoriesFromName(
      String categoryRole) async {
    List<CategoryModel> result = [];
    String jsonString =
        await rootBundle.loadString("assets/data/categories.json");
    var jsonData = json.decode(jsonString);
    var data = jsonData[categoryRole];
    for (var item in data) {
      CategoryModel category = CategoryModel.fromJson(item);
      result.add(category);
    }
    return result;
  }

  Future<List<CategoryModel>> getOwnCategories() async {
    List<String>? jsonCategories =
        sharedPreferences.getStringList(AppConstants.CATEGORIES) ?? [];
    return jsonCategories
        .map((category) => CategoryModel.fromJson(json.decode(category)))
        .toList();
  }

  Future<void> saveOwnCategories(List<CategoryModel> categories) async {
    List<String> jsonCategories =
        categories.map((category) => json.encode(category.toJson())).toList();
    await sharedPreferences.setStringList(
        AppConstants.CATEGORIES, jsonCategories);
  }
}
