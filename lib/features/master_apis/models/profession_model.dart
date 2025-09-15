
class ProfessionModel {
  int? id;
  String? profession;
  int? isDeleted;
  String? createdAt;

  ProfessionModel({this.id, this.profession, this.isDeleted, this.createdAt});

  ProfessionModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["profession"] is String) {
      profession = json["profession"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<ProfessionModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProfessionModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["profession"] = profession;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}