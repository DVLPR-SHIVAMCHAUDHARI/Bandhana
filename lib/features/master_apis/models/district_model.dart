class DistrictModel {
  int? districtId;
  int? stateId;
  String? districtName;
  int? isDeleted;
  String? createdAt;

  DistrictModel({
    this.districtId,
    this.stateId,
    this.districtName,
    this.isDeleted,
    this.createdAt,
  });

  DistrictModel.fromJson(Map<String, dynamic> json) {
    if (json["district_id"] is int) {
      districtId = json["district_id"];
    }
    if (json["state_id"] is int) {
      stateId = json["state_id"];
    }
    if (json["district_name"] is String) {
      districtName = json["district_name"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<DistrictModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(DistrictModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["district_id"] = districtId;
    data["state_id"] = stateId;
    data["district_name"] = districtName;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
