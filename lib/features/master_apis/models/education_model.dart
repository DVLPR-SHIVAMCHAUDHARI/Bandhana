
class EducationModel {
  int? id;
  String? education;
  int? isDeleted;
  String? createdAt;

  EducationModel({this.id, this.education, this.isDeleted, this.createdAt});

  EducationModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["education"] is String) {
      education = json["education"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<EducationModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(EducationModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["education"] = education;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}