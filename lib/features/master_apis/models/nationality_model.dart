class NationalityModel {
  int? id;
  String? nationality;
  String? nationalityCode;
  String? mobileCode;
  int? isDeleted;
  String? createdAt;

  NationalityModel({
    this.id,
    this.nationality,
    this.nationalityCode,
    this.mobileCode,
    this.isDeleted,
    this.createdAt,
  });

  NationalityModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["nationality"] is String) {
      nationality = json["nationality"];
    }
    if (json["nationality_code"] is String) {
      nationalityCode = json["nationality_code"];
    }
    if (json["mobile_code"] is String) {
      mobileCode = json["mobile_code"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<NationalityModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NationalityModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["nationality"] = nationality;
    data["nationality_code"] = nationalityCode;
    data["mobile_code"] = mobileCode;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
