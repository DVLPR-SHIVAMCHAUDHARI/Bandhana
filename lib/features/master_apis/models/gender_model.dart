
class GenderModel {
  int? id;
  String? name;
  int? isDeleted;
  String? createdAt;

  GenderModel({this.id, this.name, this.isDeleted, this.createdAt});

  GenderModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<GenderModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(GenderModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}