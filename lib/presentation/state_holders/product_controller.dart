import 'package:get/get.dart';
import '../../data/models/product_list_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class ProductController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ProductListModel _productListModel = ProductListModel();
  ProductListModel get productListModel => _productListModel;

  Future<bool> getProductList({required int categoryId}) async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final response =
    await NetworkCaller().getRequest(Urls.productsByCategory(categoryId));

    _inProgress = false;

    if (response.isSuccess) {
      // ---------------------------------------
      // 1️⃣ API success → but check if data null
      // ---------------------------------------
      if (response.responseData == null ||
          response.responseData["data"] == null ||
          (response.responseData["data"] as List).isEmpty) {
        // load dummy products
        _productListModel = _getDummyProducts(categoryId);
      } else {
        // load real data
        _productListModel = ProductListModel.fromJson(response.responseData);
      }

      isSuccess = true;
    } else {
      // ---------------------------------------
      // 2️⃣ API failed → load dummy product
      // ---------------------------------------
      _errorMessage = response.errorMessage;
      _productListModel = _getDummyProducts(categoryId);
      isSuccess = true;
    }

    update();
    return isSuccess;
  }

  // ---------------------------------------
  // 3️⃣ Dummy product generator method
  // ---------------------------------------
  ProductListModel _getDummyProducts(int categoryId) {
    return ProductListModel(
      msg: "Dummy Products Loaded",
      productList: [
        ProductModel(
          id: 1,
          title: "Dummy Product 1",
          price: "199",
          shortDes: "This is a dummy product for testing.",
          image: "https://placehold.co/600x400?text=Product+1",
          categoryId: categoryId,
        ),
        ProductModel(
          id: 2,
          title: "Dummy Product 2",
          price: "299",
          shortDes: "Another dummy product for UI testing.",
          image: "https://placehold.co/600x400?text=Product+2",
          categoryId: categoryId,
        ),
        ProductModel(
          id: 3,
          title: "Dummy Product 3",
          price: "399",
          shortDes: "Third dummy product sample.",
          image: "https://placehold.co/600x400?text=Product+3",
          categoryId: categoryId,
        ),
      ],
    );
  }
}
