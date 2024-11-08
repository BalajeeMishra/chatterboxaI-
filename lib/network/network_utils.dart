import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../extensions/shared_pref.dart';
// import '../screens/sign_in_screen.dart';
import '../../extensions/extension_util/int_extensions.dart';
import '../extensions/common.dart';
import '../extensions/constants.dart';
import '../extensions/system_utils.dart';
import '../main.dart';
import '../utils/app_config.dart';
import '../utils/app_constants.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (userStore.isLoggedIn ) {
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => 'Bearer ${userStore.token}');
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

// Future<http.Response> buildHttpResponse(String endPoint,
//     {HttpMethod method = HttpMethod.GET, Map? request}) async {
//   if (!await isNetworkAvailable()) {
//     throw errorInternetNotAvailable;
//   }
//
//   var headers = await buildHeaderTokens();
//   Uri url = buildBaseUrl(endPoint);
//
//   http.Response response;
//
//   try {
//     if (method == HttpMethod.POST) {
//       log('Request: $request');
//       response =
//           await http.post(url, body: jsonEncode(request), headers: headers);
//     } else if (method == HttpMethod.DELETE) {
//       response = await http.delete(url, headers: headers);
//     } else if (method == HttpMethod.PUT) {
//       response =
//           await http.put(url, body: jsonEncode(request), headers: headers);
//     } else if (method == HttpMethod.PATCH) {
//       response =
//           await http.patch(url, body: jsonEncode(request), headers: headers);
//     } else {
//       response = await http.get(url, headers: headers);
//     }
//
//     log('Response ($method): ${response.statusCode} ${response.body}');
//
//     // If response is 401, attempt to refresh the token and retry the request
//     if (response.statusCode == 401) {
//       String? newAccessToken = await refreshToken();
//       if (newAccessToken != null) {
//         userStore.token = newAccessToken;
//
//         headers[HttpHeaders.authorizationHeader] = 'Bearer $newAccessToken';
//
//         // Retry the request with the new access token
//         if (method == HttpMethod.POST) {
//           response =
//               await http.post(url, body: jsonEncode(request), headers: headers);
//         } else if (method == HttpMethod.DELETE) {
//           response = await http.delete(url, headers: headers);
//         } else if (method == HttpMethod.PUT) {
//           response =
//               await http.put(url, body: jsonEncode(request), headers: headers);
//         } else if (method == HttpMethod.PATCH) {
//           response = await http.patch(url, headers: headers);
//         } else {
//           response = await http.get(url, headers: headers);
//         }
//
//         log('Retried Response ($method): ${response.statusCode} ${response.body}');
//       } else {
//         throw Exception('Failed to refresh token');
//       }
//     }
//
//     return response;
//   } catch (e) {
//     log('Error: $e');
//     throw e;
//   }
// }

Future<Response> buildHttpResponse(String endPoint, {HttpMethod method = HttpMethod.GET, Map? request}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);

    Response response;

    if (method == HttpMethod.POST) {
      log('Request: $request');
      response =
      await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethod.DELETE) {
      response = await http.delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response =
      await http.put(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethod.PATCH) {
      response =
      await http.patch(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await http.get(url, headers: headers);
    }

    log('Response ($method): ${response.statusCode} ${response.body}');

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

@deprecated
Future<Response> getRequest(String endPoint) async =>
    buildHttpResponse(endPoint);

@deprecated
Future<Response> postRequest(String endPoint, Map request) async =>
    buildHttpResponse(endPoint, request: request, method: HttpMethod.POST);

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    var string = await (isJsonValid(response.body));
    if (string!.isNotEmpty) {
      if (string.toString().contains("Unauthenticated")) {
        await removeKey(IS_LOGIN);
        // await removeKey(USER_ID);
        await removeKey(FIRSTNAME);
        await removeKey(LASTNAME);

        await removeKey(PHONE_NUMBER);

        // await removeKey(WEIGHT);
        // await removeKey(WEIGHT_UNIT);
        userStore.clearUserData();
        // if (getBoolAsync(IS_SOCIAL) || !getBoolAsync(IS_REMEMBER)) {
        //   await removeKey(PASSWORD);
        //   await removeKey(EMAIL);
        // }
        // userStore.setLogin(false);
        // push(SignInScreen(), isNewTask: true);
      } else {
        throw string;
      }
    } else {
      throw 'Please try again later.';
    }
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT, PATCH }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  String toString() => "FormatException: $message";
}
//endregion

Future<String?> isJsonValid(json) async {
  try {
    var f = jsonDecode(json) as Map<String, dynamic>;
    return f['message'];
  } catch (e) {
    log(e.toString());
    return "";
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<MultipartRequest> getPutMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('PUT', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response =
      await http.Response.fromStream(await multiPartRequest.send());

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}


