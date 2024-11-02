import '../Model/AllConversationModel.dart';
import '../Model/ChangeStatusModel.dart';
import '../Model/base_response.dart';
import '../Model/registerResponse.dart';

import 'network_utils.dart';

Future<RegisterResponse> registerApi(Map req) async {
  return RegisterResponse.fromJson(await handleResponse(await buildHttpResponse(
      'user/register',
      request: req,
      method: HttpMethod.POST)));
}

Future<AllConversationResponse> allConversationApi(String sessionId) async {
  return AllConversationResponse.fromJson(await handleResponse(
      await buildHttpResponse('allconversation?session=$sessionId',
          method: HttpMethod.GET)));
}

Future<ChangeStatusModel> statusCheckApi(Map req,
    {String? userId}) async {
  return ChangeStatusModel.fromJson(await handleResponse(
      await buildHttpResponse('user/changestatus/$userId',
          request: req, method: HttpMethod.PATCH)));
}
Future<ChatterboxAiBaseResponse> mobileNumberCheckApi(Map req,
    ) async {
  return ChatterboxAiBaseResponse.fromJson(await handleResponse(
      await buildHttpResponse('user/checkphoneno',
          request: req, method: HttpMethod.POST)));
}
