class BasicCompatiblityModel {
  int? id;
  int? caste; // id
  String? casteName; // display
  int? income;
  String? incomeName;
  int? userId;
  int? religion;
  String? religionName;
  List<Education>? educaion;
  List<Profession>? profession;
  int? ageRange1;
  int? ageRange2;
  int? heightRange1;
  int? heightRange2;
  List<District>? workLocation1;
  List<District>? workLocation2;
  List<District>? workLocation3;
  List<District>? nativeLocation1;
  List<District>? nativeLocation2;
  List<District>? nativeLocation3;
  String? otherExpectations;
  bool? error;
  String? code;

  BasicCompatiblityModel({
    this.id,
    this.caste,
    this.casteName,
    this.income,
    this.incomeName,
    this.userId,
    this.religion,
    this.religionName,
    this.educaion,
    this.profession,
    this.ageRange1,
    this.ageRange2,
    this.heightRange1,
    this.heightRange2,
    this.workLocation1,
    this.workLocation2,
    this.workLocation3,
    this.nativeLocation1,
    this.nativeLocation2,
    this.nativeLocation3,
    this.otherExpectations,
    this.error,
    this.code,
  });

  factory BasicCompatiblityModel.fromJson(Map<String, dynamic> json) {
    List<District>? parseDistrictList(dynamic list) {
      if (list == null) return [];
      return (list as List).map((e) => District.fromJson(e)).toList();
    }

    return BasicCompatiblityModel(
      id: json['id'],
      caste: json['caste'],
      casteName: json['caste_name'],
      income: json['income'],
      incomeName: json['income_name'],
      userId: json['user_id'],
      religion: json['religion'],
      religionName: json['religion_name'],
      educaion: json['educaion'] != null
          ? List<Education>.from(
              json['educaion'].map((e) => Education.fromJson(e)),
            )
          : [],
      profession: json['profession'] != null
          ? List<Profession>.from(
              json['profession'].map((e) => Profession.fromJson(e)),
            )
          : [],
      ageRange1: json['age_range_1'],
      ageRange2: json['age_range_2'],
      heightRange1: json['height_range_1'],
      heightRange2: json['height_range_2'],
      workLocation1: parseDistrictList(json['work_location_1']),
      workLocation2: parseDistrictList(json['work_location_2']),
      workLocation3: parseDistrictList(json['work_location_3']),
      nativeLocation1: parseDistrictList(json['native_location_1']),
      nativeLocation2: parseDistrictList(json['native_location_2']),
      nativeLocation3: parseDistrictList(json['native_location_3']),
      otherExpectations: json['other_expectations'],
      error: json['error'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "caste": caste,
      "caste_name": casteName,
      "income": income,
      "income_name": incomeName,
      "user_id": userId,
      "religion": religion,
      "religion_name": religionName,
      "educaion": educaion?.map((e) => e.toJson()).toList(),
      "profession": profession?.map((e) => e.toJson()).toList(),
      "age_range_1": ageRange1,
      "age_range_2": ageRange2,
      "height_range_1": heightRange1,
      "height_range_2": heightRange2,
      "work_location_1": workLocation1?.map((e) => e.toJson()).toList(),
      "work_location_2": workLocation2?.map((e) => e.toJson()).toList(),
      "work_location_3": workLocation3?.map((e) => e.toJson()).toList(),
      "native_location_1": nativeLocation1?.map((e) => e.toJson()).toList(),
      "native_location_2": nativeLocation2?.map((e) => e.toJson()).toList(),
      "native_location_3": nativeLocation3?.map((e) => e.toJson()).toList(),
      "other_expectations": otherExpectations,
      "error": error,
      "code": code,
    };
  }
}

class District {
  int? id;
  String? districtName;

  District({this.id, this.districtName});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(id: json['id'], districtName: json['district_name']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "district_name": districtName};
  }
}

class Education {
  String? id;
  String? education;

  Education({this.id, this.education});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(id: json['id'], education: json['education']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "education": education};
  }
}

class Profession {
  String? id;
  String? profession;

  Profession({this.id, this.profession});

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(id: json['id'], profession: json['profession']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "profession": profession};
  }
}
