import '../Model/AllConversationModel.dart';
import '../Model/CheckMobileNumberResponse.dart';
import '../Model/CheckStatusModel.dart';
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
      await buildHttpResponse('allconversation?sessionId=$sessionId',
          method: HttpMethod.GET)));
}

Future<CheckStatusModel> statusCheckApi(
    {String? userId}) async {
  return CheckStatusModel.fromJson(await handleResponse(
      await buildHttpResponse('user/checkstatus/$userId',
          method: HttpMethod.GET)));
}
Future<CheckPhoneNumberResponse> mobileNumberCheckApi(Map req,
    ) async {
  return CheckPhoneNumberResponse.fromJson(await handleResponse(
      await buildHttpResponse('user/checkphoneno',
          request: req, method: HttpMethod.POST)));
}
