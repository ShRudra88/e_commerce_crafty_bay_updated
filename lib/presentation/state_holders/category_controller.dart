import 'package:get/get.dart';
import '../../data/models/category_list_model.dart';
import '../../data/models/category_list_item_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class CategoryController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  CategoryListModel _categoryListModel = CategoryListModel();
  CategoryListModel get categoryListModel => _categoryListModel;

  Future<bool> getCategoryList() async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.categoryList);

    _inProgress = false;

    if (response.isSuccess) {
      if (response.responseData == null ||
          response.responseData["data"] == null ||
          response.responseData["data"]["results"] == null ||
          (response.responseData["data"]["results"] as List).isEmpty) {
        _categoryListModel = _dummyCategories();
      } else {
        _categoryListModel = CategoryListModel.fromJson(response.responseData);
      }
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
      _categoryListModel = _dummyCategories();
      isSuccess = true;
    }

    update();
    return isSuccess;
  }

  // ------------------------------------------------
  // UPDATED DUMMY CATEGORIES WITH REAL PICTURES
  // ------------------------------------------------
  CategoryListModel _dummyCategories() {
    return CategoryListModel(
      msg: "Dummy categories loaded",
      total: 10,
      next: null,
      lastPage: 1,
      categoryListItem: [
        CategoryListItem(
          id: 1,
          categoryName: "Electronics",
          categoryImg: "https://picsum.photos/seed/electronics/200",
        ),
        CategoryListItem(
          id: 2,
          categoryName: "Fashion",
          categoryImg: "https://picsum.photos/seed/fashion/200",
        ),
        CategoryListItem(
          id: 3,
          categoryName: "Grocery",
          categoryImg: "https://picsum.photos/seed/grocery/200",
        ),
        CategoryListItem(
          id: 4,
          categoryName: "Home Decor",
          categoryImg: "https://picsum.photos/seed/homedecor/200",
        ),
        CategoryListItem(
          id: 5,
          categoryName: "Beauty",
          categoryImg: "https://picsum.photos/seed/beauty/200",
        ),
        CategoryListItem(
          id: 6,
          categoryName: "Sports",
          categoryImg: "https://picsum.photos/seed/sports/200",
        ),
        CategoryListItem(
          id: 7,
          categoryName: "Toys",
          categoryImg: "https://picsum.photos/seed/toys/200",
        ),
        CategoryListItem(
          id: 8,
          categoryName: "Furniture",
          categoryImg: "https://picsum.photos/seed/furniture/200",
        ),
        CategoryListItem(
          id: 9,
          categoryName: "Books",
          categoryImg: "https://picsum.photos/seed/books/200",
        ),
        CategoryListItem(
          id: 10,
          categoryName: "Automobile",
          categoryImg: "https://picsum.photos/seed/automobile/200",
        ),
      ],
    );
  }
}
