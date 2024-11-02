class ChatterboxAiBaseResponse {
  String? message;

  ChatterboxAiBaseResponse({this.message});

  ChatterboxAiBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}