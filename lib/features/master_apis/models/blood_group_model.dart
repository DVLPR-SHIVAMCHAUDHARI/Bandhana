
class BloodGroupModel {
  int? id;
  String? bloodGroup;
  int? isDeleted;
  String? createdAt;

  BloodGroupModel({this.id, this.bloodGroup, this.isDeleted, this.createdAt});

  BloodGroupModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["blood_group"] is String) {
      bloodGroup = json["blood_group"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<BloodGroupModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(BloodGroupModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["blood_group"] = bloodGroup;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}