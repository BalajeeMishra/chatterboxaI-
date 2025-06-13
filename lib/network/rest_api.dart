import 'dart:async';

import '../Model/AllConversationModel.dart';
import '../Model/CheckMobileNumberResponse.dart';
import '../Model/CheckStatusModel.dart';
import '../Model/conversation_model.dart';
import '../Model/registerResponse.dart';

import '../Model/updateProficiencyModel.dart';
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

Future<CheckStatusModel> statusCheckApi({String? userId}) async {
  return CheckStatusModel.fromJson(await handleResponse(await buildHttpResponse(
      'user/checkstatus/$userId',
      method: HttpMethod.GET)));
}

Future<CheckPhoneNumberResponse> mobileNumberCheckApi(
  Map req,
) async {
  return CheckPhoneNumberResponse.fromJson(await handleResponse(
      await buildHttpResponse('user/checkphoneno',
          request: req, method: HttpMethod.POST)));
}

Future<CheckPhoneNumberResponse> emailCheckApi(Map req) async {
  return CheckPhoneNumberResponse.fromJson(await handleResponse(
      await buildHttpResponse('user/auth/google',
          request: req, method: HttpMethod.POST)));
}

Future<UpdateProficiencyModel> updateProficiencyApi(
  Map req,
) async {
  return UpdateProficiencyModel.fromJson(await handleResponse(
      await buildHttpResponse('user/changeproficiency',
          request: req, method: HttpMethod.PUT)));
}

Future<CorrectSentenceModel?> correctSentenceApi(Map req) async {
  CorrectSentenceModel model =
      CorrectSentenceModel(response: Response(text: req['sentence']));
  try {
    final response = await handleResponse(
      await buildHttpResponse('correctsentance',
          request: req, method: HttpMethod.POST),
    ).timeout(Duration(seconds: 3));

    print("return corrected sentence");
    final model1 = CorrectSentenceModel.fromJson(response);
    print(model1.response!.text);
    return model1;
  } on TimeoutException {
    print("⏱️ Request timed out after 3 seconds.");
    return model;
  } catch (e) {
    print("❌ Other error: $e");
    return model;
  }
}
