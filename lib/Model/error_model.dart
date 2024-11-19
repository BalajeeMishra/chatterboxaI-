class ErrorModal {
  int? responseCode;
  int? responseStatus;
  String? responseMsg;

  ErrorModal({this.responseCode, this.responseStatus, this.responseMsg});

  ErrorModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseStatus = json['response_status'];
    responseMsg = json['response_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['response_status'] = responseStatus;
    data['response_msg'] = responseMsg;
    return data;
  }
}
