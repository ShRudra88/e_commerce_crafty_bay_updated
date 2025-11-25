import 'package:get/get.dart';

import '../../data/models/product_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';
import '../../data/models/product_model.dart';

class SpecialProductController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  ProductListModel _productListModel = ProductListModel();
  ProductListModel get productListModel => _productListModel;

  Future<bool> getSpecialProductList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.specialProduct);

    _inProgress = false;

    if (response.isSuccess) {
      _productListModel = ProductListModel.fromJson(response.responseData);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;

      /// Dummy Special Products (stars → int)
      _productListModel = ProductListModel(
        msg: "Dummy special products loaded",
        productList: [
          ProductModel(
            id: 201,
            title: "Premium Leather Wallet",
            price: "799",
            shortDes: "Hand-stitched men’s leather wallet",
            image: "https://placehold.co/600x400?text=Leather+Wallet",
            categoryId: 7,
            star: 5,
          ),
          ProductModel(
            id: 202,
            title: "Noise Cancelling Earbuds",
            price: "1699",
            shortDes: "Wireless earbuds with Active Noise Cancellation",
            image: "https://placehold.co/600x400?text=Earbuds",
            categoryId: 2,
            star: 4,
          ),
          ProductModel(
            id: 203,
            title: "DSLR Camera Stand",
            price: "1299",
            shortDes: "Professional tripod stand for photography",
            image: "https://placehold.co/600x400?text=Camera+Stand",
            categoryId: 9,
            star: 5,
          ),
          ProductModel(
            id: 204,
            title: "Wireless Keyboard",
            price: "999",
            shortDes: "Slim wireless keyboard for office use",
            image: "https://placehold.co/600x400?text=Keyboard",
            categoryId: 3,
            star: 4,
          ),
          ProductModel(
            id: 205,
            title: "Mini Portable Fan",
            price: "299",
            shortDes: "Rechargeable portable mini fan",
            image: "https://placehold.co/600x400?text=Portable+Fan",
            categoryId: 1,
            star: 4,
          ),
          ProductModel(
            id: 206,
            title: "Laptop Cooling Pad",
            price: "699",
            shortDes: "Dual-fan laptop cooling pad",
            image: "https://placehold.co/600x400?text=Cooling+Pad",
            categoryId: 3,
            star: 4,
          ),
          ProductModel(
            id: 207,
            title: "Fitness Band",
            price: "1499",
            shortDes: "Tracks heart rate & daily steps",
            image: "https://placehold.co/600x400?text=Fitness+Band",
            categoryId: 4,
            star: 4,
          ),
          ProductModel(
            id: 208,
            title: "Metal Water Bottle",
            price: "499",
            shortDes: "Insulated stainless steel bottle",
            image: "https://placehold.co/600x400?text=Water+Bottle",
            categoryId: 8,
            star: 5,
          ),
          ProductModel(
            id: 209,
            title: "Gaming Keyboard RGB",
            price: "1399",
            shortDes: "RGB backlit mechanical keyboard",
            image: "https://placehold.co/600x400?text=RGB+Keyboard",
            categoryId: 1,
            star: 5,
          ),
          ProductModel(
            id: 210,
            title: "Travel Backpack",
            price: "1899",
            shortDes: "Waterproof durable travel backpack",
            image: "https://placehold.co/600x400?text=Backpack",
            categoryId: 6,
            star: 5,
          ),
        ],
      );

      isSuccess = true;
    }

    update();
    return isSuccess;
  }
}
