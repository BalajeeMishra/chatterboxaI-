class CheckPhoneNumberResponse {
  User? user;
  String? accessToken;

  CheckPhoneNumberResponse({this.user, this.accessToken});

  CheckPhoneNumberResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['accessToken'] = accessToken;
    return data;
  }
}

class User {
  String? sId;
  String? mobileNo;
  String? name;
  int? age;
  String? nativeLanguage;
  bool? verified;
  String? role;
  String? country;
  bool? playingstatus;
  String? engprolevel;
  int? iV;
  String? lastActive;
  // String? createdAt;
  String? updatedAt;

  User(
      {this.sId,
        this.mobileNo,
        this.name,
        this.age,
        this.nativeLanguage,
        this.verified,
        this.role,
        this.country,
        this.playingstatus,
        this.engprolevel,
        this.iV,
        this.lastActive,
        // this.createdAt,
        this.updatedAt,});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobileNo = json['mobileNo'];
    name = json['name'];
    age = json['age'];
    nativeLanguage = json['nativeLanguage'];
    verified = json['verified'];
    role = json['role'];
    country = json['country'];
    playingstatus = json['playingstatus'];
    engprolevel=  json['engprolevel'];
    iV = json['__v'];
    lastActive = json['lastActive'];
    // createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['mobileNo'] = mobileNo;
    data['name'] = name;
    data['age'] = age;
    data['nativeLanguage'] = nativeLanguage;
    data['verified'] = verified;
    data['role'] = role;
    data['country'] = country;
    data['playingstatus'] = playingstatus;
    data['engprolevel']= engprolevel;
    data['__v'] = iV;
    data['lastActive'] = lastActive;
    // data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}