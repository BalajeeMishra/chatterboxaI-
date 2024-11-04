class CheckPhoneNumberResponse {
  User? user;
  String? accessToken;

  CheckPhoneNumberResponse({this.user, this.accessToken});

  CheckPhoneNumberResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['accessToken'] = this.accessToken;
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
  int? iV;

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
        this.iV});

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
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['age'] = this.age;
    data['nativeLanguage'] = this.nativeLanguage;
    data['verified'] = this.verified;
    data['role'] = this.role;
    data['country'] = this.country;
    data['playingstatus'] = this.playingstatus;
    data['__v'] = this.iV;
    return data;
  }
}