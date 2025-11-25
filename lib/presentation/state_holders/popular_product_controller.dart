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
      /// API FAILED → Dummy product list
      _errorMessage = response.errorMessage;

      _productListModel = ProductListModel(
        msg: "Dummy popular products loaded",
        productList: getDummyPopularProducts(),
      );

      isSuccess = true;
    }

    update();
    return isSuccess;
  }

  /// 🔥 10 Highly Relevant Dummy Popular Products
  List<ProductModel> getDummyPopularProducts() {
    return [
      ProductModel(
        id: 101,
        title: "Wireless Headphone",
        price: "1299",
        shortDes: "High-quality wireless headphones with deep bass",
        image: "https://dummyjson.com/image/400x300?text=Headphone",
        categoryId: 5,
      ),
      ProductModel(
        id: 102,
        title: "Smart Watch Pro",
        price: "2499",
        shortDes: "Advanced smartwatch with heart rate & SpO2 monitor",
        image: "https://dummyjson.com/image/400x300?text=Smart+Watch",
        categoryId: 3,
      ),
      ProductModel(
        id: 103,
        title: "Portable Bluetooth Speaker",
        price: "899",
        shortDes: "Crystal clear sound with powerful bass",
        image: "https://dummyjson.com/image/400x300?text=Speaker",
        categoryId: 2,
      ),
      ProductModel(
        id: 104,
        title: "RGB Gaming Mouse",
        price: "599",
        shortDes: "Ergonomic gaming mouse with RGB lighting",
        image: "https://dummyjson.com/image/400x300?text=Gaming+Mouse",
        categoryId: 1,
      ),
      ProductModel(
        id: 105,
        title: "4K Action Camera",
        price: "3299",
        shortDes: "Ultra HD waterproof action camera",
        image: "https://dummyjson.com/image/400x300?text=Action+Camera",
        categoryId: 6,
      ),
      ProductModel(
        id: 106,
        title: "Fast Charging Power Bank 20000mAh",
        price: "1499",
        shortDes: "PD fast charging power bank with dual output",
        image: "https://dummyjson.com/image/400x300?text=Power+Bank",
        categoryId: 7,
      ),
      ProductModel(
        id: 107,
        title: "Wireless Earbuds",
        price: "999",
        shortDes: "Touch control earbuds with noise cancellation",
        image: "https://dummyjson.com/image/400x300?text=Earbuds",
        categoryId: 5,
      ),
      ProductModel(
        id: 108,
        title: "Laptop Cooling Pad",
        price: "799",
        shortDes: "Cooling pad with 6 LED fans for gaming laptops",
        image: "https://dummyjson.com/image/400x300?text=Cooling+Pad",
        categoryId: 1,
      ),
      ProductModel(
        id: 109,
        title: "DSLR Camera Tripod",
        price: "1199",
        shortDes: "Adjustable tripod stand for DSLR & mobile",
        image: "https://dummyjson.com/image/400x300?text=Tripod",
        categoryId: 8,
      ),
      ProductModel(
        id: 110,
        title: "Premium Leather Wallet",
        price: "499",
        shortDes: "Genuine leather slim wallet",
        image: "https://dummyjson.com/image/400x300?text=Wallet",
        categoryId: 9,
      ),
    ];
  }
}
