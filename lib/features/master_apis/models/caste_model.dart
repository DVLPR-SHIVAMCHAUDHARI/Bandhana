class CasteModel {
  int? id;
  int? religionId;
  String? caste;
  int? isDeleted;
  String? createdAt;

  CasteModel({
    this.id,
    this.religionId,
    this.caste,
    this.isDeleted,
    this.createdAt,
  });

  CasteModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["religion_id"] is int) {
      religionId = json["religion_id"];
    }
    if (json["caste"] is String) {
      caste = json["caste"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<CasteModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CasteModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["religion_id"] = religionId;
    data["caste"] = caste;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
