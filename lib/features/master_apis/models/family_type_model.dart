
class FamilyTypeModel {
  int? id;
  String? familyType;
  int? isDeleted;
  String? createdAt;

  FamilyTypeModel({this.id, this.familyType, this.isDeleted, this.createdAt});

  FamilyTypeModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["family_type"] is String) {
      familyType = json["family_type"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<FamilyTypeModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyTypeModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["family_type"] = familyType;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}