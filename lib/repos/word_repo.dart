import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/word_model.dart';

class WordRepo {
  final SharedPreferences sharedPreferences;

  WordRepo({required this.sharedPreferences});

  Future<List<WordModel>> getWords() async {
    return _getWordsFromName('allWords');
  }

  Future<List<WordModel>> getEnWords() async {
    return _getWordsFromName('allWordsEn');
  }

  Future<List<WordModel>> getDaWords() async {
    return _getWordsFromName('allWordsDa');
  }

  Future<List<WordModel>> _getWordsFromName(String wordRole) async {
    List<WordModel> result = [];
    String jsonString = await rootBundle.loadString("assets/data/words.json");
    var jsonData = json.decode(jsonString);
    var data = jsonData[wordRole];
    for (var item in data) {
      WordModel word = WordModel.fromJson(item);
      result.add(word);
    }
    return result;
  }
}
