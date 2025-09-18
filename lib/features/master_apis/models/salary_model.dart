class SalaryModel {
  int? id;
  String? salaryRange;
  int? isDeleted;
  String? createdAt;

  SalaryModel({this.id, this.salaryRange, this.isDeleted, this.createdAt});

  SalaryModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["salary_range"] is String) {
      salaryRange = json["salary_range"];
    }
    if (json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<SalaryModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(SalaryModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["salary_range"] = salaryRange;
    data["is_deleted"] = isDeleted;
    data["created_at"] = createdAt;
    return data;
  }
}
