class ZodiacModel {
  int? id;
  String? zodiac;
  int? isDeleted;
  String? createdAt;

  ZodiacModel({this.id, this.zodiac, this.isDeleted, this.createdAt});

  ZodiacModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["zodiac"] is String) {
      zodiac = json["zodiac"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<ZodiacModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ZodiacModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["zodiac"] = zodiac;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
