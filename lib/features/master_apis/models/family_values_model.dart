
class FamilyValuesModel {
  int? id;
  String? familyValue;
  int? isDeleted;
  String? createdAt;

  FamilyValuesModel({this.id, this.familyValue, this.isDeleted, this.createdAt});

  FamilyValuesModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["family_value"] is String) {
      familyValue = json["family_value"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<FamilyValuesModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyValuesModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["family_value"] = familyValue;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}