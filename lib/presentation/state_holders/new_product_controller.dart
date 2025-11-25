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
  // Dummy New Products (Total: 10)
  // ------------------------------------------------
  ProductListModel _dummyNewProducts() {
    return ProductListModel(
      msg: "Dummy New Products Loaded",
      productList: [
        ProductModel(
          id: 201,
          title: "New Arrival Shirt",
          price: "550",
          shortDes: "Premium cotton shirt",
          image: "https://placehold.co/600x400?text=Shirt",
          categoryId: 1,
        ),
        ProductModel(
          id: 202,
          title: "Smart Watch X20",
          price: "1200",
          shortDes: "Stylish and lightweight smart watch",
          image: "https://placehold.co/600x400?text=Smart+Watch",
          categoryId: 2,
        ),
        ProductModel(
          id: 203,
          title: "Running Shoes Pro",
          price: "2400",
          shortDes: "Comfortable running shoes for daily use",
          image: "https://placehold.co/600x400?text=Running+Shoes",
          categoryId: 3,
        ),
        ProductModel(
          id: 204,
          title: "Wireless Earbuds V5",
          price: "1500",
          shortDes: "Noise-cancelling Bluetooth earbuds",
          image: "https://placehold.co/600x400?text=Earbuds",
          categoryId: 4,
        ),
        ProductModel(
          id: 205,
          title: "Laptop Sleeve 15-inch",
          price: "700",
          shortDes: "Water-resistant laptop sleeve",
          image: "https://placehold.co/600x400?text=Laptop+Sleeve",
          categoryId: 5,
        ),
        ProductModel(
          id: 206,
          title: "Bluetooth Speaker Mini",
          price: "900",
          shortDes: "Portable mini speaker",
          image: "https://placehold.co/600x400?text=Speaker",
          categoryId: 4,
        ),
        ProductModel(
          id: 207,
          title: "Travel Backpack",
          price: "1800",
          shortDes: "Lightweight waterproof backpack",
          image: "https://placehold.co/600x400?text=Backpack",
          categoryId: 6,
        ),
        ProductModel(
          id: 208,
          title: "Sports Water Bottle",
          price: "350",
          shortDes: "Stainless steel insulated bottle",
          image: "https://placehold.co/600x400?text=Water+Bottle",
          categoryId: 7,
        ),
        ProductModel(
          id: 209,
          title: "Desk LED Lamp",
          price: "950",
          shortDes: "Adjustable LED desk lamp",
          image: "https://placehold.co/600x400?text=LED+Lamp",
          categoryId: 8,
        ),
        ProductModel(
          id: 210,
          title: "Gaming Mouse RGB",
          price: "1100",
          shortDes: "High DPI RGB gaming mouse",
          image: "https://placehold.co/600x400?text=Gaming+Mouse",
          categoryId: 9,
        ),
      ],
    );
  }
}
