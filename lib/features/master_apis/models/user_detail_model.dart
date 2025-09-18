class UserDetailModel {
  int? id;
  String? kul;
  String? caste;
  String? email;
  String? state;
  String? gender;
  String? zodiac;
  List<Hobbies>? hobbies;
  int? userId;
  String? district;
  String? fullname;
  String? religion;
  String? disablity;
  String? birthTime;
  String? birthPlace;
  String? bloodGroup;
  String? nationality;
  String? dateOfBirth;
  String? motherTongue;
  String? contactNumber;
  String? maritalStatus;
  String? specificDisablity;
  bool? error;
  String? code;

  UserDetailModel({
    this.id,
    this.kul,
    this.caste,
    this.email,
    this.state,
    this.gender,
    this.zodiac,
    this.hobbies,
    this.userId,
    this.district,
    this.fullname,
    this.religion,
    this.disablity,
    this.birthTime,
    this.birthPlace,
    this.bloodGroup,
    this.nationality,
    this.dateOfBirth,
    this.motherTongue,
    this.contactNumber,
    this.maritalStatus,
    this.specificDisablity,
    this.error,
    this.code,
  });

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["kul"] is String) {
      kul = json["kul"];
    }
    if (json["caste"] is String) {
      caste = json["caste"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["gender"] is String) {
      gender = json["gender"];
    }
    if (json["zodiac"] is String) {
      zodiac = json["zodiac"];
    }
    if (json["hobbies"] is List) {
      hobbies = json["hobbies"] == null
          ? null
          : (json["hobbies"] as List).map((e) => Hobbies.fromJson(e)).toList();
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["district"] is String) {
      district = json["district"];
    }
    if (json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if (json["religion"] is String) {
      religion = json["religion"];
    }
    if (json["disablity"] is String) {
      disablity = json["disablity"];
    }
    if (json["birth_time"] is String) {
      birthTime = json["birth_time"];
    }
    if (json["birth_place"] is String) {
      birthPlace = json["birth_place"];
    }
    if (json["blood_group"] is String) {
      bloodGroup = json["blood_group"];
    }
    if (json["nationality"] is String) {
      nationality = json["nationality"];
    }
    if (json["date_of_birth"] is String) {
      dateOfBirth = json["date_of_birth"];
    }
    if (json["mother_tongue"] is String) {
      motherTongue = json["mother_tongue"];
    }
    if (json["contact_number"] is String) {
      contactNumber = json["contact_number"];
    }
    if (json["marital_status"] is String) {
      maritalStatus = json["marital_status"];
    }
    if (json["specific_disablity"] is String) {
      specificDisablity = json["specific_disablity"];
    }
    if (json["error"] is bool) {
      error = json["error"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
  }

  static List<UserDetailModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserDetailModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["kul"] = kul;
    data["caste"] = caste;
    data["email"] = email;
    data["state"] = state;
    data["gender"] = gender;
    data["zodiac"] = zodiac;
    if (hobbies != null) {
      data["hobbies"] = hobbies?.map((e) => e.toJson()).toList();
    }
    data["user_id"] = userId;
    data["district"] = district;
    data["fullname"] = fullname;
    data["religion"] = religion;
    data["disablity"] = disablity;
    data["birth_time"] = birthTime;
    data["birth_place"] = birthPlace;
    data["blood_group"] = bloodGroup;
    data["nationality"] = nationality;
    data["date_of_birth"] = dateOfBirth;
    data["mother_tongue"] = motherTongue;
    data["contact_number"] = contactNumber;
    data["marital_status"] = maritalStatus;
    data["specific_disablity"] = specificDisablity;
    data["error"] = error;
    data["code"] = code;
    return data;
  }
}

class Hobbies {
  String? id;
  String? hobbyName;

  Hobbies({this.id, this.hobbyName});

  Hobbies.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["hobby_name"] is String) {
      hobbyName = json["hobby_name"];
    }
  }

  static List<Hobbies> fromList(List<Map<String, dynamic>> list) {
    return list.map(Hobbies.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["hobby_name"] = hobbyName;
    return data;
  }
}
