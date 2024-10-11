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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_status'] = this.responseStatus;
    data['response_msg'] = this.responseMsg;
    return data;
  }
}
