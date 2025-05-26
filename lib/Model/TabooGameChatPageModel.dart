class TabooGameChatPageModel {
  Response?   response;

  TabooGameChatPageModel({this.response});

  TabooGameChatPageModel.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
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
  String? sessionId;
  String? engProLevel;
  String? modality;
  int? count;
  String?text;
  // String? sId;
  // int? iV;

  Response(
      {this.userId,
      this.userResponse,
      this.aiResponse,
      this.sessionId,
      this.engProLevel,
      this.modality,
      this.count,
        this.text,
      // this.sId,
      // this.iV
      });

  Response.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userResponse = json['userResponse'].cast<String>();
    aiResponse = json['aiResponse'].cast<String>();
    sessionId = json['sessionId'];
    engProLevel = json['engprolevel'];
    modality = json['modality'];
    count = json['count'];
    text = json['text'];
    // sId = json['_id'];
    // iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userResponse'] = userResponse;
    data['aiResponse'] = aiResponse;
    data['sessionId'] = sessionId;
    data['engprolevel'] = engProLevel;
    data['modality'] = modality;
    data['count'] = count;
    data['text'] = text;
    // data['_id'] = sId;
    // data['__v'] = iV;
    return data;
  }
}
