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
  String ? email;
  String? name;
  int? age;
  String? nativeLanguage;
  bool? verified;
  String? role;
  String? country;
  String? userId;
  String? engprolevel;
  bool? playingstatus;
  int? iV;
  String? lastActive;
  String? createdAt;
  String? updatedAt;

  NewUser(
      {this.mobileNo,
        this.name,
        this.age,
        this.nativeLanguage,
        this.verified,
        this.role,
        this.country,
        this.userId,
        this.iV,
        this.lastActive,
        this.createdAt,
        this.updatedAt,this.email});

  NewUser.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    name = json['name'];
    email = json['email'];
    age = json['age'];
    nativeLanguage = json['nativeLanguage'];
    verified = json['verified'];
    role = json['role'];
    country = json['country'];
    userId = json['_id'];
    playingstatus = json['playingstatus'];
    engprolevel=  json['engprolevel'];
    iV = json['__v'];
    lastActive = json['lastActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNo'] = mobileNo;
    data['name'] = name;
    data['email']= email;
    data['age'] = age;
    data['nativeLanguage'] = nativeLanguage;
    data['verified'] = verified;
    data['role'] = role;
    data['country'] = country;
    data['_id'] = userId;
    data['playingstatus'] = playingstatus;
    data['engprolevel']= engprolevel;
    data['__v'] = iV;
    data['lastActive'] = lastActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}