
class CasteModel {
  int? id;
  int? religionId;
  String? caste;
  int? isDeleted;
  String? createdAt;

  CasteModel({this.id, this.religionId, this.caste, this.isDeleted, this.createdAt});

  CasteModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["religion_id"] is int) {
      religionId = json["religion_id"];
    }
    if(json["caste"] is String) {
      caste = json["caste"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<CasteModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CasteModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["religion_id"] = religionId;
    _data["caste"] = caste;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}