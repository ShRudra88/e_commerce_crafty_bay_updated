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
      // ----------------------------
      // API SUCCESS BUT CHECK NULL
      // ----------------------------
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
      // ----------------------------
      // API FAILED → dummy data
      // ----------------------------
      _errorMessage = response.errorMessage;
      _categoryListModel = _dummyCategories();
      isSuccess = true;
    }

    update();
    return isSuccess;
  }

  // ------------------------------------------------
  // DUMMY CATEGORIES FOR OFFLINE / ERROR CONDITION
  // ------------------------------------------------
  CategoryListModel _dummyCategories() {
    return CategoryListModel(
      msg: "Dummy categories loaded",
      total: 6,
      next: null,
      lastPage: 1,
      categoryListItem: [
        CategoryListItem(
          id: 1,
          categoryName: "Electronics",
          categoryImg: "https://placehold.co/200x200?text=Electronics",
        ),
        CategoryListItem(
          id: 2,
          categoryName: "Fashion",
          categoryImg: "https://placehold.co/200x200?text=Fashion",
        ),
        CategoryListItem(
          id: 3,
          categoryName: "Grocery",
          categoryImg: "https://placehold.co/200x200?text=Grocery",
        ),
        CategoryListItem(
          id: 4,
          categoryName: "Home Decor",
          categoryImg: "https://placehold.co/200x200?text=Home+Decor",
        ),
        CategoryListItem(
          id: 5,
          categoryName: "Beauty",
          categoryImg: "https://placehold.co/200x200?text=Beauty",
        ),
        CategoryListItem(
          id: 6,
          categoryName: "Sports",
          categoryImg: "https://placehold.co/200x200?text=Sports",
        ),
      ],
    );
  }
}
