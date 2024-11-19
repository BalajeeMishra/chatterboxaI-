class ChangeStatusModel {
  Updateduser? updateduser;

  ChangeStatusModel({this.updateduser});

  ChangeStatusModel.fromJson(Map<String, dynamic> json) {
    updateduser = json['updateduser'] != null
        ? Updateduser.fromJson(json['updateduser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (updateduser != null) {
      data['updateduser'] = updateduser!.toJson();
    }
    return data;
  }
}

class Updateduser {
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

  Updateduser(
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

  Updateduser.fromJson(Map<String, dynamic> json) {
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
    data['__v'] = iV;
    return data;
  }
}
