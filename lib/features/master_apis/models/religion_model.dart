
class ReligionModel {
  int? id;
  String? religion;
  int? isDeleted;
  String? createdAt;

  ReligionModel({this.id, this.religion, this.isDeleted, this.createdAt});

  ReligionModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["religion"] is String) {
      religion = json["religion"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<ReligionModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReligionModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["religion"] = religion;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}