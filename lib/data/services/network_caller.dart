import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../../presentation/state_holders/auth_controller.dart';
import '../models/response_data.dart';

class NetworkCaller {
  Future<ResponseData> getRequest(String url, {String? token}) async {
    log(url);
    log(token.toString());
    try {
      final Response response = await GetConnect().get(
        url,
        headers: {
          'token': (token ?? AuthController.token).toString(),
          'Content-type': 'application/json'
        },
      );
      log('Response Headers: ${response.headers.toString()}');
      log('Status Code: ${response.statusCode.toString()}');
      log('Response Body: ${response.body.toString()}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.bodyString ?? '{}');
        if (decodedResponse['msg'] == 'success') {
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode!,
            responseData: decodedResponse,
          );
        } else {
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode!,
            responseData: decodedResponse,
            errorMessage: decodedResponse['data']?.toString() ?? 'Something went wrong',
          );
        }
      } else if (response.statusCode == 401) {
        await AuthController.clearAuthData();
        AuthController.goToLogin();
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode!,
          responseData: '',
          errorMessage: 'Unauthorized',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode!,
          responseData: response.bodyString ?? '',
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error in getRequest: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        responseData: '',
        errorMessage: 'Network Error: $e',
      );
    }
  }

  Future<ResponseData> postRequest(String url,
      {Map<String, dynamic>? body, String? token}) async {
    log(url);
    log(body.toString());
    try {
      final Response response = await GetConnect().post(
        url,
        jsonEncode(body),
        headers: {
          'token': (token ?? AuthController.token).toString(),
          'Content-type': 'application/json'
        },
      );
      log('Status Code: ${response.statusCode.toString()}');
      log('Response Body: ${response.body.toString()}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.bodyString ?? '{}');
        if (decodedResponse['msg'] == 'success') {
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode!,
            responseData: decodedResponse,
          );
        } else {
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode!,
            responseData: decodedResponse,
            errorMessage: decodedResponse['data']?.toString() ?? 'Something went wrong',
          );
        }
      } else if (response.statusCode == 401) {
        await AuthController.clearAuthData();
        AuthController.goToLogin();
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode!,
          responseData: '',
          errorMessage: 'Unauthorized',
        );
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode!,
          responseData: response.bodyString ?? '',
          errorMessage: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      log('Error in postRequest: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: -1,
        responseData: '',
        errorMessage: 'Network Error: $e',
      );
    }
  }
}
