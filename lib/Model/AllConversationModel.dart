class AllConversationResponse {
  CompleteConversation? completeConversation;

  AllConversationResponse({this.completeConversation});

  AllConversationResponse.fromJson(Map<String, dynamic> json) {
    completeConversation = json['completeConversation'] != null
        ? CompleteConversation.fromJson(json['completeConversation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (completeConversation != null) {
      data['completeConversation'] = completeConversation!.toJson();
    }
    return data;
  }
}

class CompleteConversation {
  String? sId;
  String? userId;
  List<String>? userResponse;
  List<String>? aiResponse;
  String? sessionId;
  int? iV;

  CompleteConversation(
      {this.sId,
        this.userId,
        this.userResponse,
        this.aiResponse,
        this.sessionId,
        this.iV});

  CompleteConversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    userResponse = json['userResponse'].cast<String>();
    aiResponse = json['aiResponse'].cast<String>();
    sessionId = json['sessionId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userId'] = userId;
    data['userResponse'] = userResponse;
    data['aiResponse'] = aiResponse;
    data['sessionId'] = sessionId;
    data['__v'] = iV;
    return data;
  }
}