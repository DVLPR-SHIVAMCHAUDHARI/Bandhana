
class FamilyDetailsModel {
  int? id;
  int? userId;
  int? familyType;
  String? fathersName;
  String? mothersName;
  int? familyStatus;
  int? familyValues;
  int? noOfSisters;
  String? mamasKulClan;
  int? noOfBrothers;
  String? fathersContact;
  String? mothersContact;
  String? familyTypeName;
  String? familyStatusName;
  String? familyValuesName;
  String? fathersOccupation;
  String? mothersOccupation;
  String? maternalUncleMamasName;
  String? relativesFamilySurnames;
  String? maternalUncleMamasVillage;
  bool? error;
  String? code;

  FamilyDetailsModel({this.id, this.userId, this.familyType, this.fathersName, this.mothersName, this.familyStatus, this.familyValues, this.noOfSisters, this.mamasKulClan, this.noOfBrothers, this.fathersContact, this.mothersContact, this.familyTypeName, this.familyStatusName, this.familyValuesName, this.fathersOccupation, this.mothersOccupation, this.maternalUncleMamasName, this.relativesFamilySurnames, this.maternalUncleMamasVillage, this.error, this.code});

  FamilyDetailsModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    if(json["family_type"] is int) {
      familyType = json["family_type"];
    }
    if(json["fathers_name"] is String) {
      fathersName = json["fathers_name"];
    }
    if(json["mothers_name"] is String) {
      mothersName = json["mothers_name"];
    }
    if(json["family_status"] is int) {
      familyStatus = json["family_status"];
    }
    if(json["family_values"] is int) {
      familyValues = json["family_values"];
    }
    if(json["no_of_sisters"] is int) {
      noOfSisters = json["no_of_sisters"];
    }
    if(json["mamas_kul_clan"] is String) {
      mamasKulClan = json["mamas_kul_clan"];
    }
    if(json["no_of_brothers"] is int) {
      noOfBrothers = json["no_of_brothers"];
    }
    if(json["fathers_contact"] is String) {
      fathersContact = json["fathers_contact"];
    }
    if(json["mothers_contact"] is String) {
      mothersContact = json["mothers_contact"];
    }
    if(json["family_type_name"] is String) {
      familyTypeName = json["family_type_name"];
    }
    if(json["family_status_name"] is String) {
      familyStatusName = json["family_status_name"];
    }
    if(json["family_values_name"] is String) {
      familyValuesName = json["family_values_name"];
    }
    if(json["fathers_occupation"] is String) {
      fathersOccupation = json["fathers_occupation"];
    }
    if(json["mothers_occupation"] is String) {
      mothersOccupation = json["mothers_occupation"];
    }
    if(json["maternal_uncle_mamas_name"] is String) {
      maternalUncleMamasName = json["maternal_uncle_mamas_name"];
    }
    if(json["relatives_family_surnames"] is String) {
      relativesFamilySurnames = json["relatives_family_surnames"];
    }
    if(json["maternal_uncle_mamas_village"] is String) {
      maternalUncleMamasVillage = json["maternal_uncle_mamas_village"];
    }
    if(json["error"] is bool) {
      error = json["error"];
    }
    if(json["code"] is String) {
      code = json["code"];
    }
  }

  static List<FamilyDetailsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyDetailsModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["user_id"] = userId;
    _data["family_type"] = familyType;
    _data["fathers_name"] = fathersName;
    _data["mothers_name"] = mothersName;
    _data["family_status"] = familyStatus;
    _data["family_values"] = familyValues;
    _data["no_of_sisters"] = noOfSisters;
    _data["mamas_kul_clan"] = mamasKulClan;
    _data["no_of_brothers"] = noOfBrothers;
    _data["fathers_contact"] = fathersContact;
    _data["mothers_contact"] = mothersContact;
    _data["family_type_name"] = familyTypeName;
    _data["family_status_name"] = familyStatusName;
    _data["family_values_name"] = familyValuesName;
    _data["fathers_occupation"] = fathersOccupation;
    _data["mothers_occupation"] = mothersOccupation;
    _data["maternal_uncle_mamas_name"] = maternalUncleMamasName;
    _data["relatives_family_surnames"] = relativesFamilySurnames;
    _data["maternal_uncle_mamas_village"] = maternalUncleMamasVillage;
    _data["error"] = error;
    _data["code"] = code;
    return _data;
  }
}