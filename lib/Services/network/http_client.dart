//this class holds base urls, api methods, tokens , headers

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../Constants/ApiURLConstant.dart';

class ApiClass {
  static String _baseUrl = baseUrl;

  /// Creating Header With Authenticated Data
  static Future<Map<String, String>> getHeaders({isHeader = false}) async {
    print("Get Header function Called");
    //checkUserRegistration? token = await MySharedPreferences.getMobileVerificationData();
    return ({
      "Content-Type": "application/json",
      ...(isHeader != null
          ? {
              'token': "",
            }
          : {})
    });
  }

  /// Get Method With Header Checks
  static Future<Response> get(String endPoint, {bool isHeader = true}) async {
    final headers = await getHeaders(isHeader: isHeader);
    print("Header passed $headers");
    print("Get API Api Url $_baseUrl$endPoint");
    var response;
    try {
      response = await http.get(Uri.parse("$_baseUrl$endPoint"), headers: headers).timeout(const Duration(seconds: 30));
    } on SocketException {
      throw "No Internet Connection";
    } on TimeoutException {
      throw 'Network Request time out';
    }
    return response;
  }

  /// POST Method With Header Checks
  static Future<Response> post(String endPoint, Map<String, dynamic> object, {bool isHeader = true}) async {
    final headers = await getHeaders(isHeader: isHeader);
    print("Header passed $headers");
    var response;
    print("ApiUrl $_baseUrl$endPoint");
    print("data to be passed $object");
    try {
      response = await http
          .post(Uri.parse("$_baseUrl$endPoint"), body: jsonEncode(object), headers: headers)
          .timeout(const Duration(seconds: 30));
      print("Api Response http class ${response.body}");
    } on SocketException {
      throw "No Internet Connection";
    } on TimeoutException {
      throw 'Network Request time out';
    }
    return response;
  }

  /// PATCH Method With Header Checks
  static Future<Response> patch(String endPoint, Object object, {bool isHeader = true}) async {
    final headers = await getHeaders(isHeader: isHeader);
    print("Header passed $headers");
    var response;
    try {
      response = await http
          .patch(Uri.parse("$_baseUrl$endPoint"), body: object, headers: headers)
          .timeout(const Duration(seconds: 30));
    } on SocketException {
      throw "No Internet Connection";
    } on TimeoutException {
      throw 'Network Request time out';
    }
    return response;
  }

  /// DELETE Method With Header Checks
  static Future<Response> delete(String endPoint, {bool isHeader = true}) async {
    Map<String, String> headers = isHeader ? await getHeaders() : {};
    print("Header passed $headers");
    var response;
    try {
      response =
          await http.delete(Uri.parse("$_baseUrl$endPoint"), headers: headers).timeout(const Duration(seconds: 30));
    } on SocketException {
      throw "No Internet Connection";
    } on TimeoutException {
      throw 'Network Request time out';
    }
    return response;
  }
}