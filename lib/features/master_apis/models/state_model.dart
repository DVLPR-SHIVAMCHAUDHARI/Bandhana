
class StateModel {
  int? stateId;
  int? nationalityId;
  String? stateName;
  int? isDeleted;
  String? createdAt;

  StateModel({this.stateId, this.nationalityId, this.stateName, this.isDeleted, this.createdAt});

  StateModel.fromJson(Map<String, dynamic> json) {
    if(json["state_id"] is int) {
      stateId = json["state_id"];
    }
    if(json["nationality_id"] is int) {
      nationalityId = json["nationality_id"];
    }
    if(json["state_name"] is String) {
      stateName = json["state_name"];
    }
    if(json["is_deleted"] is int) {
      isDeleted = json["is_deleted"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<StateModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(StateModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["state_id"] = stateId;
    _data["nationality_id"] = nationalityId;
    _data["state_name"] = stateName;
    _data["is_deleted"] = isDeleted;
    _data["created_at"] = createdAt;
    return _data;
  }
}