

class TabooGameChatPageModel {
  Response? response;

  TabooGameChatPageModel({this.response});

  TabooGameChatPageModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? userId;
  List<String>? userResponse;
  List<String>? aiResponse;
  int? session;
  String? sId;
  int? iV;

  Response(
      {this.userId,
      this.userResponse,
      this.aiResponse,
      this.session,
      this.sId,
      this.iV});

  Response.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userResponse = json['userResponse'].cast<String>();
    aiResponse = json['aiResponse'].cast<String>();
    session = json['session'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userResponse'] = this.userResponse;
    data['aiResponse'] = this.aiResponse;
    data['session'] = this.session;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}