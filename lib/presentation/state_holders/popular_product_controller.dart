import 'package:get/get.dart';

import '../../data/models/product_list_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class PopularProductController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ProductListModel _productListModel = ProductListModel();
  ProductListModel get productListModel => _productListModel;

  Future<bool> getPopularProductList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.popularProduct);

    _inProgress = false;

    if (response.isSuccess) {
      /// API SUCCESS → Parse real data
      _productListModel = ProductListModel.fromJson(response.responseData);
      isSuccess = true;
    } else {
      /// API FAILED → Use dummy popular products
      _errorMessage = response.errorMessage;

      _productListModel = ProductListModel(
        msg: "Dummy popular products loaded",
        productList: [
          ProductModel(
            id: 101,
            title: "Popular Headphone",
            price: "1299",
            shortDes: "High quality wireless headphones",
            image: "https://placehold.co/600x400?text=Headphone",
            categoryId: 5,
          ),
          ProductModel(
            id: 102,
            title: "Smart Watch",
            price: "2499",
            shortDes: "Fitness tracking smartwatch",
            image: "https://placehold.co/600x400?text=Smart+Watch",
            categoryId: 3,
          ),
          ProductModel(
            id: 103,
            title: "Bluetooth Speaker",
            price: "899",
            shortDes: "Portable Bluetooth speaker",
            image: "https://placehold.co/600x400?text=Speaker",
            categoryId: 2,
          ),
          ProductModel(
            id: 104,
            title: "Gaming Mouse",
            price: "599",
            shortDes: "RGB gaming mouse with high DPI",
            image: "https://placehold.co/600x400?text=Gaming+Mouse",
            categoryId: 1,
          ),
        ],
      );

      isSuccess = true; // fallback works
    }

    update();
    return isSuccess;
  }
}
