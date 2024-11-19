
class AllGameModel {
  List<AllGame>? allGame;

  AllGameModel({this.allGame});

  AllGameModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['gameId'] = gameId;
    data['mainContent'] = mainContent;
    data['level'] = level;
    data['detailOfContent'] = detailOfContent;
    data['__v'] = iV;
    return data;
  }
}