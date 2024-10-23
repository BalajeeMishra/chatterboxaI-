import 'dart:convert';
import 'package:http/http.dart';

import '../../extensions/extension_util/int_extensions.dart';
import '../../extensions/extension_util/string_extensions.dart';
import '../Model/registerResponse.dart';
import '../extensions/shared_pref.dart';
import '../main.dart';

import 'network_utils.dart';

// Future<LoginResponse> logInApi(request) async {
//   Response response = await buildHttpResponse('login',
//       request: request, method: HttpMethod.POST);
//   if (!response.statusCode.isSuccessful()) {
//     if (response.body.isJson()) {
//       var json = jsonDecode(response.body);
//
//       if (json.containsKey('code') &&
//           json['code'].toString().contains('invalid_username')) {
//         throw 'invalid_username';
//       }
//     }
//   }
//
//   return await handleResponse(response).then((value) async {
//     LoginResponse loginResponse = LoginResponse.fromJson(value);
//     // UserModel? userResponse = loginResponse.data;
//
//     // saveUserData(userResponse);
//     await userStore.setLogin(true);
//     return loginResponse;
//   });
// }
// // Future<void> saveUserData(UserModel? userModel) async {
// //   if (userModel!.apiToken.validate().isNotEmpty) await userStore.setToken(userModel.apiToken.validate());
// //   setValue(IS_SOCIAL, false);
// //
// //   await userStore.setToken(userModel.apiToken.validate());
// //   // await userStore.setUserID(userModel.id.validate());
// //   // await userStore.setUserEmail(userModel.email.validate());
// //   // await userStore.setFirstName(userModel.firstName.validate());
// //   // await userStore.setLastName(userModel.lastName.validate());
// //   // await userStore.setUsername(userModel.username.validate());
// //   // await userStore.setUserImage(userModel.profileImage.validate());
// //   // await userStore.setDisplayName(userModel.displayName.validate());
// //   // await userStore.setPhoneNo(userModel.phoneNumber.validate());
// // }
//
// Future<RegisterResponse> socialLogInApi(Map req) async {
//   return RegisterResponse.fromJson(await handleResponse(await buildHttpResponse(
//       'social-media-login',
//       request: req,
//       method: HttpMethod.POST)));
// }

// Future<MediVahanBaseResponse> updateProfileApi(Map req, {int? id}) async {
//   return MediVahanBaseResponse.fromJson(await handleResponse(
//       await buildHttpResponse('user/update-details/$id',
//           request: req, method: HttpMethod.PUT)));
// }

// Future<PrescriptionCreateResponse> prescriptionCreateApi(Map req) async {
//   return PrescriptionCreateResponse.fromJson(await handleResponse(
//       await buildHttpResponse('prescription/create',
//           request: req, method: HttpMethod.POST)));
// }

Future<RegisterResponse> registerApi(
  Map req,
) async {
  return RegisterResponse.fromJson(await handleResponse(await buildHttpResponse(
      'user/register',
      request: req,
      method: HttpMethod.POST)));
}
