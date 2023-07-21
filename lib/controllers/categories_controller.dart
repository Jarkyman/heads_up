import 'package:get/get.dart';
import '../models/category_model.dart';
import '../repos/category_repo.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<CategoryModel> _eventCategories = []; //TODO: Add til events
  List<CategoryModel> get eventCategories => _eventCategories;

  List<CategoryModel> _ownCategories = [];
  List<CategoryModel> get ownCategories => _ownCategories;

  Future<void> readAllCategories() async {
    await readCategories();
    await readEventCategories();
    await readOwnCategories();
  }

  Future<void> readCategories() async {
    List<CategoryModel> categories = await categoryRepo.getCategories();
    _categories = [];
    _categories = categories;
  }

  Future<void> readEventCategories() async {
    List<CategoryModel> categories = await categoryRepo.getEventCategories();
    _eventCategories = [];
    _eventCategories = categories;
  }

  Future<void> readOwnCategories() async {
    List<CategoryModel> categories = await categoryRepo.getOwnCategories();
    _ownCategories = [];
    _ownCategories = categories;
  }

  Future<void> saveOwnCategory(CategoryModel category) async {
    _ownCategories.add(category);
    await categoryRepo.saveOwnCategories(_ownCategories);
    update();
  }
}
