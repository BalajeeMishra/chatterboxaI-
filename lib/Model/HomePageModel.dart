

class HomePageModel {
  List<AllGame>? allGame;

  HomePageModel({this.allGame});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    if (json['allGame'] != null) {
      allGame = <AllGame>[];
      json['allGame'].forEach((v) {
        allGame!.add(AllGame.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (allGame != null) {
      data['allGame'] = allGame!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllGame {
  String? sId;
  String? gameName;
  String? gameIcon;
  String? description;
  String? status;
  int? order;
  int? iV;

  AllGame(
      {this.sId,
        this.gameName,
        this.gameIcon,
        this.description,
        this.status,
        this.order,
        this.iV});

  AllGame.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gameName = json['gameName'];
    gameIcon = json['gameIcon'];
    description = json['description'];
    status = json['status'];
    order = json['order'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['gameName'] = gameName;
    data['gameIcon'] = gameIcon;
    data['description'] = description;
    data['status'] = status;
    data['order'] = order;
    data['__v'] = iV;
    return data;
  }
}