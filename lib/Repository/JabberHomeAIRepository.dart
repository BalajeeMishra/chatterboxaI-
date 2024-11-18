

import 'dart:convert';

import 'package:balajiicode/Constants/ApiURLConstant.dart';

import '../Model/HomePageModel.dart';
import '../Model/error_model.dart';
import '../Services/ApiResponseStatus.dart';
import '../Services/network/http_client.dart';

class JabberHomeAIRepository{

  Future<ApiResponse<HomePageModel>> homePageApiCallFunction() async {
    try {
      final response = await ApiClass.get(homepageAPI, isHeader: true);
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (status == ApiResponseStatus.success) {
        final data = HomePageModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = ErrorModal.fromJson(responseData);
        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw e.toString();
    }
  }

}