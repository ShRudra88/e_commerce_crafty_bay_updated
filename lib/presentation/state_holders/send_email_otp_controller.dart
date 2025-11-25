// import 'package:get/get.dart';
//
// import '../../data/models/response_data.dart';
// import '../../data/services/network_caller.dart';
// import '../../data/utility/urls.dart';
//
// class SendEmailOtpController extends GetxController {
//   bool _inProgress = false;
//
//   bool get inProgress => _inProgress;
//
//   String _errorMessage = '';
//
//   String get errorMessage => _errorMessage;
//
//   Future<bool> sendOtpToEmail(String email) async {
//     _inProgress = true;
//     update();
//     final ResponseData response =
//     await NetworkCaller().getRequest(Urls.sentEmailOtp(email));
//     _inProgress = false;
//     if (response.isSuccess) {
//       update();
//       return true;
//     } else {
//       _errorMessage = response.errorMessage;
//       update();
//       return false;
//     }
//   }
// }

import 'package:get/get.dart';

import '../../data/models/response_data.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class SendEmailOtpController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<bool> sendOtpToEmail(String email) async {
    _inProgress = true;
    update();

    // ✅ Add Default Email + OTP Logic
    if (email == "test123@gmail.com") {
      await Future.delayed(const Duration(seconds: 1));
      _inProgress = false;
      update();
      return true; // Always success for default test account
    }

    // 🔥 Otherwise call API normally
    final ResponseData response =
    await NetworkCaller().getRequest(Urls.sentEmailOtp(email));

    _inProgress = false;
    if (response.isSuccess) {
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      update();
      return false;
    }
  }
}
