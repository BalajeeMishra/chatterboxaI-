
class AllGameModel {
  List<AllGame>? allGame;

  AllGameModel({this.allGame});

  AllGameModel.fromJson(Map<String, dynamic> json) {
    if (json['allGame'] != null) {
      allGame = <AllGame>[];
      json['allGame'].forEach((v) {
        allGame!.add(new AllGame.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allGame != null) {
      data['allGame'] = this.allGame!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllGame {
  String? sId;
  String? gameId;
  String? mainContent;
  String? level;
  List<String>? detailOfContent;
  int? iV;

  AllGame(
      {this.sId,
        this.gameId,
        this.mainContent,
        this.level,
        this.detailOfContent,
        this.iV});

  AllGame.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gameId = json['gameId'];
    mainContent = json['mainContent'];
    level = json['level'];
    detailOfContent = json['detailOfContent'].cast<String>();
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['gameId'] = this.gameId;
    data['mainContent'] = this.mainContent;
    data['level'] = this.level;
    data['detailOfContent'] = this.detailOfContent;
    data['__v'] = this.iV;
    return data;
  }
}