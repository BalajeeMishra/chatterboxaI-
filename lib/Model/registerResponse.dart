class RegisterResponse {
  String? accessToken;
  NewUser? newUser;

  RegisterResponse({this.accessToken, this.newUser});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    newUser =
    json['newUser'] != null ? NewUser.fromJson(json['newUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    if (newUser != null) {
      data['newUser'] = newUser!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNo'] = mobileNo;
    data['name'] = name;
    data['age'] = age;
    data['nativeLanguage'] = nativeLanguage;
    data['verified'] = verified;
    data['role'] = role;
    data['country'] = country;
    data['_id'] = userId;
    data['__v'] = iV;
    return data;
  }
}