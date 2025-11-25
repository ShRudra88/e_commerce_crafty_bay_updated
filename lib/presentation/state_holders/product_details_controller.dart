import 'package:get/get.dart';
import '../../data/models/product_details_data.dart';
import '../../data/models/product_details_model.dart';
import '../../data/models/response_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class ProductDetailsController extends GetxController {
  bool _inProgress = false;
  ProductDetailsModel? _productDetailsModel;
  String _errorMessage = '';

  bool get inProgress => _inProgress;

  ProductDetailsData? get productDetails {
    if (_productDetailsModel == null ||
        _productDetailsModel!.productDetailsDataList == null ||
        _productDetailsModel!.productDetailsDataList!.isEmpty) {
      return null;
    }
    return _productDetailsModel!.productDetailsDataList!.first;
  }

  String get errorMessage => _errorMessage;

  Future<bool> getProductDetails(int productId) async {
    _inProgress = true;
    update();

    final ResponseData response =
    await NetworkCaller().getRequest(Urls.productDetails(productId));

    bool isSuccess = false;

    if (response.isSuccess) {
      _productDetailsModel =
          ProductDetailsModel.fromJson(response.responseData);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
