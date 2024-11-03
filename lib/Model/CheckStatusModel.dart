class CheckStatusModel {
  bool? playingstatus;

  CheckStatusModel({this.playingstatus});

  CheckStatusModel.fromJson(Map<String, dynamic> json) {
    playingstatus = json['playingstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playingstatus'] = this.playingstatus;
    return data;
  }
}