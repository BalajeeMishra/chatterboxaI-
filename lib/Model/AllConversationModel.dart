class AllConversationResponse {
  CompleteConversation? completeConversation;

  AllConversationResponse({this.completeConversation});

  AllConversationResponse.fromJson(Map<String, dynamic> json) {
    completeConversation = json['completeConversation'] != null
        ? new CompleteConversation.fromJson(json['completeConversation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.completeConversation != null) {
      data['completeConversation'] = this.completeConversation!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['userResponse'] = this.userResponse;
    data['aiResponse'] = this.aiResponse;
    data['sessionId'] = this.sessionId;
    data['__v'] = this.iV;
    return data;
  }
}