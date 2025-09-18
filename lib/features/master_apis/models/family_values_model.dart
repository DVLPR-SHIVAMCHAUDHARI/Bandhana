class FamilyValuesModel {
  int? id;
  String? familyValue;
  int? isDeleted;
  String? createdAt;

  FamilyValuesModel({
    this.id,
    this.familyValue,
    this.isDeleted,
    this.createdAt,
  });

  FamilyValuesModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["family_value"] is String) {
      familyValue = json["family_value"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<FamilyValuesModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyValuesModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["family_value"] = familyValue;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
