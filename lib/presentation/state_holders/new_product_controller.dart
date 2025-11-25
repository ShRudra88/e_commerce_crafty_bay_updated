import 'package:get/get.dart';
import '../../data/models/product_list_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class NewProductController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ProductListModel _productListModel = ProductListModel();
  ProductListModel get productListModel => _productListModel;

  Future<bool> getNewProductList() async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.newProduct);

    _inProgress = false;

    if (response.isSuccess) {
      // --------------------
      // Check if null data
      // --------------------
      if (response.responseData == null ||
          response.responseData["data"] == null ||
          (response.responseData["data"] as List).isEmpty) {
        _productListModel = _dummyNewProducts();
      } else {
        _productListModel = ProductListModel.fromJson(response.responseData);
      }

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
      _productListModel = _dummyNewProducts(); // fallback
      isSuccess = true;
    }

    update();
    return isSuccess;
  }

  // ------------------------------------------------
  // Dummy New Products
  // ------------------------------------------------
  ProductListModel _dummyNewProducts() {
    return ProductListModel(
      msg: "Dummy New Products Loaded",
      productList: [
        ProductModel(
          id: 101,
          title: "New Arrival Shirt",
          price: "550",
          shortDes: "Premium cotton shirt",
          image: "https://placehold.co/600x400?text=New+Product+1",
          categoryId: 1,
        ),
        ProductModel(
          id: 102,
          title: "Smart Watch X20",
          price: "1200",
          shortDes: "Stylish smart watch",
          image: "https://placehold.co/600x400?text=New+Product+2",
          categoryId: 2,
        ),
        ProductModel(
          id: 103,
          title: "Running Shoes",
          price: "2400",
          shortDes: "Comfortable running shoes",
          image: "https://placehold.co/600x400?text=New+Product+3",
          categoryId: 3,
        ),
      ],
    );
  }
}
