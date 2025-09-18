class MotherTongueModel {
  int? id;
  String? motherTounge;
  String? createdAt;
  int? isDeleted;

  MotherTongueModel({
    this.id,
    this.motherTounge,
    this.createdAt,
    this.isDeleted,
  });

  MotherTongueModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["mother_tounge"] is String) {
      motherTounge = json["mother_tounge"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
  }

  static List<MotherTongueModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(MotherTongueModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["mother_tounge"] = motherTounge;
    data["created_at"] = createdAt;
    data["is_deleted"] = isDeleted;
    return data;
  }
}
