
import 'dart:convert';

import 'package:balajiicode/Model/AllGameModel.dart';

import '../Constants/ApiURLConstant.dart';
import '../Model/error_model.dart';
import '../Services/ApiResponseStatus.dart';
import '../Services/network/http_client.dart';

class AllGameRepository{


  Future<ApiResponse<AllGameModel>> allGameApiCallFunction(String dataId) async {
    try {
      final response = await ApiClass.get(allgame+dataId, isHeader: true);
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (status == ApiResponseStatus.success) {
        final data = AllGameModel.fromJson(responseData);
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