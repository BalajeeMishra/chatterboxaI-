class ChatterboxAiBaseResponse {
  String? message;

  ChatterboxAiBaseResponse({this.message});

  ChatterboxAiBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    return data;
  }
}
class ChatterboxAiErrorBaseResponse {
  String? message;
  String? error;

  ChatterboxAiErrorBaseResponse({this.message,this.error});

  ChatterboxAiErrorBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}