class FamilyStatusModel {
  int? id;
  String? familyStatus;
  int? isDeleted;
  String? createdAt;

  FamilyStatusModel({
    this.id,
    this.familyStatus,
    this.isDeleted,
    this.createdAt,
  });

  FamilyStatusModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["family_status"] is String) {
      familyStatus = json["family_status"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<FamilyStatusModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyStatusModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["family_status"] = familyStatus;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
