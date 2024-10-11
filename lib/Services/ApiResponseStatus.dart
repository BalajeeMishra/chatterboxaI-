

import '../Model/error_model.dart';

enum ApiResponseStatus {
  success,
  badRequest,
  unauthorized,
  notFound,
  serverError,
}

class ApiResponse<T> {
  final ErrorModal? error;
  final ApiResponseStatus status;
  final T? data;

  ApiResponse(this.status, {this.data, this.error});

  factory ApiResponse.success(T data) {
    return ApiResponse(ApiResponseStatus.success, data: data);
  }

  factory ApiResponse.error(ApiResponseStatus status, {ErrorModal? error}) {
    return ApiResponse(status, error: error);
  }
}

ApiResponseStatus mapStatusCode(int statusCode) {
  switch (statusCode) {
    case 200:
      return ApiResponseStatus.success;
    case 400:
      return ApiResponseStatus.badRequest;
    case 403:
      return ApiResponseStatus.unauthorized;
    case 404:
      return ApiResponseStatus.notFound;
    case 500:
      return ApiResponseStatus.serverError;
    default:
      throw Exception('Unknown status code: $statusCode');
  }
}
