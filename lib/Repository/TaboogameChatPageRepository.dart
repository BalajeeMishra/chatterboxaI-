

import 'dart:convert';

import 'package:balajiicode/Utils/app_common.dart';

import '../Constants/ApiURLConstant.dart';
import '../Model/TabooGameChatPageModel.dart';
import '../Model/error_model.dart';
import '../Services/ApiResponseStatus.dart';
import '../Services/network/http_client.dart';

class TabooGameChatPageRepository {
  Future<ApiResponse<TabooGameChatPageModel>> tabooGameChatPageApiCallFunction({ required Map<String, dynamic> data}) async {
    try {
      // Log the URL and data
      print("API URL: $tabooGameChatPage");
      print("Payload: $data");
      print(JsonEncoder.withIndent('  ').convert(data));

      final response = await ApiClass.post(tabooGameChatPage, data, isHeader: true);
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print("called this $responseData");
      if (status == ApiResponseStatus.success) {
        final data = TabooGameChatPageModel.fromJson(responseData);
        return ApiResponse.success(data);
      } else {
        final error = ErrorModal.fromJson(responseData);

        return ApiResponse.error(status, error: error);
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> correctUserMessageApi(Map<String , dynamic> data)async{

    try {
      // Log the URL and data
      print("API URL: $tabooGameChatPage");
      print("Payload: $data");
      print(JsonEncoder.withIndent('  ').convert(data));

      final response = await ApiClass.post(completUserMessage, data, isHeader: true);
      final ApiResponseStatus status = mapStatusCode(response.statusCode);
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (status == ApiResponseStatus.success) {
        final data = responseData.isNotEmpty?responseData['text']:'';
        return data;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}

// class TabooGameChatPageRepository{
//
//   Future<ApiResponse<TabooGameChatPageModel>> tabooGameChatPageApiCallFunction(
//       Map<String,dynamic> data
//       ) async {
//     try {
//       final response = await ApiClass.post(tabooGameChatPage,data, isHeader: true);
//       final ApiResponseStatus status = mapStatusCode(response.statusCode!);
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       if (status == ApiResponseStatus.success) {
//         final data = TabooGameChatPageModel.fromJson(responseData);
//         return ApiResponse.success(data);
//       } else {
//         final error = ErrorModal.fromJson(responseData);
//         return ApiResponse.error(status, error: error);
//       }
//     } catch (e) {
//       throw "${e.toString()}";
//     }
//   }
//
// }