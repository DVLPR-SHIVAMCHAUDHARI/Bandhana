class RegisterProfileModel {
  int? id;
  String? kul;
  int? caste;
  String? casteName;
  String? email;
  int? state;
  String? stateName;
  int? gender;
  String? genderName;
  int? zodiac;
  String? zodiacName;
  List<Hobby>? hobbies;
  int? userId;
  int? district;
  String? districtName;
  String? fullname;
  int? religion;
  String? religionName;
  String? disablity;
  String? birthTime;
  String? birthPlace;
  int? bloodGroup;
  String? bloodGroupName;
  int? nationality;
  String? nationalityName;
  String? dateOfBirth;
  int? motherTongue;
  String? motherTongueName;
  String? maritalStatus;
  String? maritalStatusName;
  String? contactNumber;
  String? specificDisablity;
  bool? error;
  String? code;

  RegisterProfileModel({
    this.id,
    this.kul,
    this.caste,
    this.casteName,
    this.email,
    this.state,
    this.stateName,
    this.gender,
    this.genderName,
    this.zodiac,
    this.zodiacName,
    this.hobbies,
    this.userId,
    this.district,
    this.districtName,
    this.fullname,
    this.religion,
    this.religionName,
    this.disablity,
    this.birthTime,
    this.birthPlace,
    this.bloodGroup,
    this.bloodGroupName,
    this.nationality,
    this.nationalityName,
    this.dateOfBirth,
    this.motherTongue,
    this.motherTongueName,
    this.maritalStatus,
    this.maritalStatusName,
    this.contactNumber,
    this.specificDisablity,
    this.error,
    this.code,
  });

  factory RegisterProfileModel.fromJson(Map<String, dynamic> json) {
    return RegisterProfileModel(
      id: json['id'],
      kul: json['kul'],
      caste: json['caste'],
      casteName: json['caste_name'],
      email: json['email'],
      state: json['state'],
      stateName: json['state_name'],
      gender: json['gender'],
      genderName: json['gender_name'],
      zodiac: json['zodiac'],
      zodiacName: json['zodiac_name'],
      hobbies: json['hobbies'] != null
          ? List<Hobby>.from(json['hobbies'].map((x) => Hobby.fromJson(x)))
          : null,
      userId: json['user_id'],
      district: json['district'],
      districtName: json['district_name'],
      fullname: json['fullname'],
      religion: json['religion'],
      religionName: json['religion_name'],
      disablity: json['disablity'],
      birthTime: json['birth_time'],
      birthPlace: json['birth_place'],
      bloodGroup: json['blood_group'],
      bloodGroupName: json['blood_group_name'],
      nationality: json['nationality'],
      nationalityName: json['nationality_name'],
      dateOfBirth: json['date_of_birth'],
      motherTongue: json['mother_tongue'],
      motherTongueName: json['mother_tongue_name'],
      maritalStatus: json['marital_status']?.toString(),
      maritalStatusName: json['marital_status_name'],
      contactNumber: json['contact_number'],
      specificDisablity: json['specific_disablity'],
      error: json['error'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'kul': kul,
    'caste': caste,
    'caste_name': casteName,
    'email': email,
    'state': state,
    'state_name': stateName,
    'gender': gender,
    'gender_name': genderName,
    'zodiac': zodiac,
    'zodiac_name': zodiacName,
    'hobbies': hobbies?.map((x) => x.toJson()).toList(),
    'user_id': userId,
    'district': district,
    'district_name': districtName,
    'fullname': fullname,
    'religion': religion,
    'religion_name': religionName,
    'disablity': disablity,
    'birth_time': birthTime,
    'birth_place': birthPlace,
    'blood_group': bloodGroup,
    'blood_group_name': bloodGroupName,
    'nationality': nationality,
    'nationality_name': nationalityName,
    'date_of_birth': dateOfBirth,
    'mother_tongue': motherTongue,
    'mother_tongue_name': motherTongueName,
    'marital_status': maritalStatus,
    'marital_status_name': maritalStatusName,
    'contact_number': contactNumber,
    'specific_disablity': specificDisablity,
    'error': error,
    'code': code,
  };
}

class Hobby {
  String? id;
  String? hobbyName;

  Hobby({this.id, this.hobbyName});

  factory Hobby.fromJson(Map<String, dynamic> json) =>
      Hobby(id: json['id'], hobbyName: json['hobby_name']);

  Map<String, dynamic> toJson() => {'id': id, 'hobby_name': hobbyName};
}
