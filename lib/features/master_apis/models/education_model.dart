class EducationModel {
  int? id;
  String? education;

  EducationModel({this.id, this.education});

  EducationModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["education"] is String) {
      education = json["education"];
    }
  }

  static List<EducationModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(EducationModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["education"] = education;

    return data;
  }
}
