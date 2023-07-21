import 'package:get/get.dart';
import 'package:heads_up/models/word_model.dart';
import 'package:heads_up/repos/word_repo.dart';

import '../models/category_model.dart';

class WordController extends GetxController implements GetxService {
  WordRepo wordRepo;

  List<WordModel> _words = [];
  List<WordModel> get words => _words;

  WordController({required this.wordRepo});

  Future<void> readAllWords() async {
    await readWords();
  }

  Future<void> readWords() async {
    List<WordModel> words = await wordRepo.getWords();
    _words = [];
    _words.addAll(words);
    _words.addAll(await _readLangWords());
  }

  Future<List<WordModel>> _readLangWords() async{
    List<WordModel> result = [];
    switch (Get.locale.toString()) { //TODO: Det her kan nok gøres anderledes måske bruge Locale('da')
      case ('da_DK'):
        result.addAll(await wordRepo.getDaWords());
        break;
      case ('en_US'):
        result.addAll(await wordRepo.getEnWords());
        break;
    }
    return result;
  }

  List<String> generateWordsListByCategory(CategoryModel category) {
    List<String> wordsList = [];

    for (WordModel word in _words) {
      for (CategoryModel wordCategory in word.category) {
        if (wordCategory.category == category.category) {
          wordsList.add(word.word);
        }
      }
    }
    wordsList.shuffle();
    print('Amout of word: ${wordsList.length}');
    return wordsList;
  }
}
