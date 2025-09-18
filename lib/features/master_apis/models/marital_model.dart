class MaritalModel {
  int? id;
  String? maritalStatus;
  int? isDeleted;
  String? createdAt;

  MaritalModel({this.id, this.maritalStatus, this.isDeleted, this.createdAt});

  MaritalModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["marital_status"] is String) {
      maritalStatus = json["marital_status"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<MaritalModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(MaritalModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["marital_status"] = maritalStatus;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
