
class HobbyModel {
  int? id;
  String? hobby;
  int? isDeleted;
  String? createdAt;

  HobbyModel({this.id, this.hobby, this.isDeleted, this.createdAt});

  HobbyModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["hobby"] is String) {
      hobby = json["hobby"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<HobbyModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(HobbyModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["hobby"] = hobby;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}