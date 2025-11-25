import 'package:get/get.dart';
import '../../data/models/banner_list_model.dart';
import '../../data/models/banner_item_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class HomeBannerController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  BannerListModel _bannerListModel = BannerListModel();
  BannerListModel get bannerListModel => _bannerListModel;

  Future<bool> getBannerList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.homeBanner);
    _inProgress = false;

    if (response.isSuccess) {
      _bannerListModel = BannerListModel.fromJson(response.responseData);

      /// If list is empty or null → load dummy banners
      if (_bannerListModel.bannerList == null ||
          _bannerListModel.bannerList!.isEmpty) {
        _bannerListModel = BannerListModel(
          msg: "Loaded Dummy Banner Data",
          bannerList: getDummyBanners(),
        );
      }

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;

      /// API failed → fallback dummy banners
      _bannerListModel = BannerListModel(
        msg: "Failed → Showing Dummy Banners",
        bannerList: getDummyBanners(),
      );
    }

    update();
    return isSuccess;
  }

  /// Dummy Banner Data (matches your BannerItem model)
  List<BannerItem> getDummyBanners() {
    return [
      BannerItem(
        id: 1,
        title: "Mega Winter Sale",
        shortDes: "Up to 50% off on winter essentials",
        image: "https://dummyjson.com/image/300x150?text=Winter+Sale",
        productId: 101,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      ),
      BannerItem(
        id: 2,
        title: "New Arrivals",
        shortDes: "Check the latest trendy products",
        image: "https://dummyjson.com/image/300x150?text=New+Arrivals",
        productId: 102,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      ),
      BannerItem(
        id: 3,
        title: "Flash Deals",
        shortDes: "Limited time offers, hurry up!",
        image: "https://dummyjson.com/image/300x150?text=Flash+Deals",
        productId: 103,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      ),
    ];
  }
}
