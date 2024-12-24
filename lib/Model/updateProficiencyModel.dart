class UpdateProficiencyModel {
  User? user;

  UpdateProficiencyModel({this.user});

  UpdateProficiencyModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
    engprolevel = json['engprolevel'];
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
    data['engprolevel'] = this.engprolevel;
    data['__v'] = this.iV;
    return data;
  }
}
