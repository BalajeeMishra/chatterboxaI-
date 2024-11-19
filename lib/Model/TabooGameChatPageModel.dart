

class TabooGameChatPageModel {
  Response? response;

  TabooGameChatPageModel({this.response});

  TabooGameChatPageModel.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? userId;
  List<String>? userResponse;
  List<String>? aiResponse;
  String? session;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userResponse'] = userResponse;
    data['aiResponse'] = aiResponse;
    data['session'] = session;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}