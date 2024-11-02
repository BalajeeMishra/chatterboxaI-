class ChangeStatusModel {
  Updateduser? updateduser;

  ChangeStatusModel({this.updateduser});

  ChangeStatusModel.fromJson(Map<String, dynamic> json) {
    updateduser = json['updateduser'] != null
        ? new Updateduser.fromJson(json['updateduser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.updateduser != null) {
      data['updateduser'] = this.updateduser!.toJson();
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
