class RegisterResponse {
  String? accessToken;
  NewUser? newUser;

  RegisterResponse({this.accessToken, this.newUser});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    newUser =
    json['newUser'] != null ? new NewUser.fromJson(json['newUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    if (this.newUser != null) {
      data['newUser'] = this.newUser!.toJson();
    }
    return data;
  }
}

class NewUser {
  String? mobileNo;
  String? name;
  int? age;
  String? nativeLanguage;
  bool? verified;
  String? role;
  String? country;
  String? userId;
  int? iV;

  NewUser(
      {this.mobileNo,
        this.name,
        this.age,
        this.nativeLanguage,
        this.verified,
        this.role,
        this.country,
        this.userId,
        this.iV});

  NewUser.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    name = json['name'];
    age = json['age'];
    nativeLanguage = json['nativeLanguage'];
    verified = json['verified'];
    role = json['role'];
    country = json['country'];
    userId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileNo'] = this.mobileNo;
    data['name'] = this.name;
    data['age'] = this.age;
    data['nativeLanguage'] = this.nativeLanguage;
    data['verified'] = this.verified;
    data['role'] = this.role;
    data['country'] = this.country;
    data['_id'] = this.userId;
    data['__v'] = this.iV;
    return data;
  }
}