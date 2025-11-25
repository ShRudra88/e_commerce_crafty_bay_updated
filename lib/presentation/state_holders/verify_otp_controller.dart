// import 'package:get/get.dart';
// import '../../data/services/network_caller.dart';
// import '../../data/utility/urls.dart';
// import 'auth_controller.dart';
// import 'read_profile_data_controller.dart';
//
//
// class VerifyOTPController extends GetxController {
//   bool _inProgress = false;
//
//   bool get inProgress => _inProgress;
//
//   String _errorMessage = '';
//
//   String get errorMessage => _errorMessage;
//
//   bool _shouldNavigateCompleteProfile = true;
//
//   bool get shouldNavigateCompleteProfile => _shouldNavigateCompleteProfile;
//
//   String _token = '';
//
//   String get token => _token;
//
//   Future<bool> verifyOTP(String email, String otp) async {
//     _inProgress = true;
//     update();
//     final response = await NetworkCaller().getRequest(Urls.verifyOtp(email, otp));
//     _inProgress = false;
//     if (response.isSuccess) {
//       _token = response.responseData['data'];
//       await Future.delayed(const Duration(seconds: 3));
//       final result =
//       await Get.find<ReadProfileDataController>().readProfileData(token);
//       if (result) {
//         _shouldNavigateCompleteProfile = Get.find<ReadProfileDataController>().isProfileCompleted == false;
//         if (_shouldNavigateCompleteProfile == false) {
//           await Get.find<AuthController>().saveUserDetails(token, Get.find<ReadProfileDataController>().profile);
//         }
//       } else {
//         _errorMessage = Get.find<ReadProfileDataController>().errorMessage;
//         update();
//         return false;
//       }
//       update();
//       return true;
//     } else {
//       _errorMessage = response.errorMessage;
//       update();
//       return false;
//     }
//   }
// }

import 'package:e_commerce_crafty_bay_updated/presentation/state_holders/read_profile_data_controller.dart';
import 'package:get/get.dart';
import '../../data/services/network_caller.dart';
import '../../data/utility/urls.dart';

class VerifyOTPController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _shouldNavigateCompleteProfile = true;
  bool get shouldNavigateCompleteProfile => _shouldNavigateCompleteProfile;

  String _token = '';
  String get token => _token;

  Future<bool> verifyOTP(String email, String otp) async {
    _inProgress = true;
    update();

    // ✅ DEFAULT TEST LOGIN (skip API)
    if (email == "test123@gmail.com" && otp == "123456") {
      await Future.delayed(const Duration(seconds: 1));

      _token = "TEST_TOKEN_123456"; // dummy

      // 🚀 Read dummy profile (skip API)
      final result = await Get.find<ReadProfileDataController>()
          .readProfileData(_token, isTestUser: true);

      _shouldNavigateCompleteProfile =
      !Get.find<ReadProfileDataController>().isProfileCompleted;

      _inProgress = false;
      update();
      return true;
    }

    // 🔥 Otherwise go to server
    final response =
    await NetworkCaller().getRequest(Urls.verifyOtp(email, otp));

    _inProgress = false;

    if (response.isSuccess) {
      _token = response.responseData['data'];

      final result = await Get.find<ReadProfileDataController>()
          .readProfileData(_token);

      if (!result) {
        _errorMessage =
            Get.find<ReadProfileDataController>().errorMessage;
        update();
        return false;
      }

      _shouldNavigateCompleteProfile =
      !Get.find<ReadProfileDataController>().isProfileCompleted;

      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      update();
      return false;
    }
  }
}
