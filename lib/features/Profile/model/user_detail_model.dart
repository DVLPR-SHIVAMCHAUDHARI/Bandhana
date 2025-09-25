
class UserDetailModel {
  ProfileDetails? profileDetails;
  ProfileSetup? profileSetup;
  PatnerLifeStylePreferences? patnerLifeStylePreferences;
  FamilyDetails? familyDetails;
  bool? error;
  String? code;

  UserDetailModel({this.profileDetails, this.profileSetup, this.patnerLifeStylePreferences, this.familyDetails, this.error, this.code});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    if(json["profile_details"] is Map) {
      profileDetails = json["profile_details"] == null ? null : ProfileDetails.fromJson(json["profile_details"]);
    }
    if(json["profile_setup"] is Map) {
      profileSetup = json["profile_setup"] == null ? null : ProfileSetup.fromJson(json["profile_setup"]);
    }
    if(json["patner_life_style_preferences"] is Map) {
      patnerLifeStylePreferences = json["patner_life_style_preferences"] == null ? null : PatnerLifeStylePreferences.fromJson(json["patner_life_style_preferences"]);
    }
    if(json["family_details"] is Map) {
      familyDetails = json["family_details"] == null ? null : FamilyDetails.fromJson(json["family_details"]);
    }
    if(json["error"] is bool) {
      error = json["error"];
    }
    if(json["code"] is String) {
      code = json["code"];
    }
  }

  static List<UserDetailModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserDetailModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(profileDetails != null) {
      _data["profile_details"] = profileDetails?.toJson();
    }
    if(profileSetup != null) {
      _data["profile_setup"] = profileSetup?.toJson();
    }
    if(patnerLifeStylePreferences != null) {
      _data["patner_life_style_preferences"] = patnerLifeStylePreferences?.toJson();
    }
    if(familyDetails != null) {
      _data["family_details"] = familyDetails?.toJson();
    }
    _data["error"] = error;
    _data["code"] = code;
    return _data;
  }
}

class FamilyDetails {
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
  dynamic maternalUncleMamasName;
  String? relativesFamilySurnames;
  String? maternalUncleMamasVillage;

  FamilyDetails({this.id, this.userId, this.familyType, this.fathersName, this.mothersName, this.familyStatus, this.familyValues, this.noOfSisters, this.mamasKulClan, this.noOfBrothers, this.fathersContact, this.mothersContact, this.familyTypeName, this.familyStatusName, this.familyValuesName, this.fathersOccupation, this.mothersOccupation, this.maternalUncleMamasName, this.relativesFamilySurnames, this.maternalUncleMamasVillage});

  FamilyDetails.fromJson(Map<String, dynamic> json) {
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
    maternalUncleMamasName = json["maternal_uncle_mamas_name"];
    if(json["relatives_family_surnames"] is String) {
      relativesFamilySurnames = json["relatives_family_surnames"];
    }
    if(json["maternal_uncle_mamas_village"] is String) {
      maternalUncleMamasVillage = json["maternal_uncle_mamas_village"];
    }
  }

  static List<FamilyDetails> fromList(List<Map<String, dynamic>> list) {
    return list.map(FamilyDetails.fromJson).toList();
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
    return _data;
  }
}

class PatnerLifeStylePreferences {
  int? id;
  String? diet;
  int? userId;
  String? petFriendly;
  String? dailyRoutine;
  String? sleepPattern;
  String? smokingHabit;
  String? drinkingHabit;
  String? fitnessActivity;
  String? travelPreferences;

  PatnerLifeStylePreferences({this.id, this.diet, this.userId, this.petFriendly, this.dailyRoutine, this.sleepPattern, this.smokingHabit, this.drinkingHabit, this.fitnessActivity, this.travelPreferences});

  PatnerLifeStylePreferences.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["diet"] is String) {
      diet = json["diet"];
    }
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    if(json["pet_friendly"] is String) {
      petFriendly = json["pet_friendly"];
    }
    if(json["daily_routine"] is String) {
      dailyRoutine = json["daily_routine"];
    }
    if(json["sleep_pattern"] is String) {
      sleepPattern = json["sleep_pattern"];
    }
    if(json["smoking_habit"] is String) {
      smokingHabit = json["smoking_habit"];
    }
    if(json["drinking_habit"] is String) {
      drinkingHabit = json["drinking_habit"];
    }
    if(json["fitness_activity"] is String) {
      fitnessActivity = json["fitness_activity"];
    }
    if(json["travel_preferences"] is String) {
      travelPreferences = json["travel_preferences"];
    }
  }

  static List<PatnerLifeStylePreferences> fromList(List<Map<String, dynamic>> list) {
    return list.map(PatnerLifeStylePreferences.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["diet"] = diet;
    _data["user_id"] = userId;
    _data["pet_friendly"] = petFriendly;
    _data["daily_routine"] = dailyRoutine;
    _data["sleep_pattern"] = sleepPattern;
    _data["smoking_habit"] = smokingHabit;
    _data["drinking_habit"] = drinkingHabit;
    _data["fitness_activity"] = fitnessActivity;
    _data["travel_preferences"] = travelPreferences;
    return _data;
  }
}

class ProfileSetup {
  int? id;
  int? age;
  String? bio;
  int? height;
  int? salary;
  int? userId;
  int? education;
  int? profession;
  String? salaryName;
  String? profileUrl1;
  String? profileUrl2;
  String? profileUrl3;
  String? profileUrl4;
  String? profileUrl5;
  String? workLocation;
  String? educationName;
  String? professionName;
  String? permanentLocation;

  ProfileSetup({this.id, this.age, this.bio, this.height, this.salary, this.userId, this.education, this.profession, this.salaryName, this.profileUrl1, this.profileUrl2, this.profileUrl3, this.profileUrl4, this.profileUrl5, this.workLocation, this.educationName, this.professionName, this.permanentLocation});

  ProfileSetup.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["age"] is int) {
      age = json["age"];
    }
    if(json["bio"] is String) {
      bio = json["bio"];
    }
    if(json["height"] is int) {
      height = json["height"];
    }
    if(json["salary"] is int) {
      salary = json["salary"];
    }
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    if(json["education"] is int) {
      education = json["education"];
    }
    if(json["profession"] is int) {
      profession = json["profession"];
    }
    if(json["salary_name"] is String) {
      salaryName = json["salary_name"];
    }
    if(json["profile_url_1"] is String) {
      profileUrl1 = json["profile_url_1"];
    }
    if(json["profile_url_2"] is String) {
      profileUrl2 = json["profile_url_2"];
    }
    if(json["profile_url_3"] is String) {
      profileUrl3 = json["profile_url_3"];
    }
    if(json["profile_url_4"] is String) {
      profileUrl4 = json["profile_url_4"];
    }
    if(json["profile_url_5"] is String) {
      profileUrl5 = json["profile_url_5"];
    }
    if(json["work_location"] is String) {
      workLocation = json["work_location"];
    }
    if(json["education_name"] is String) {
      educationName = json["education_name"];
    }
    if(json["profession_name"] is String) {
      professionName = json["profession_name"];
    }
    if(json["permanent_location"] is String) {
      permanentLocation = json["permanent_location"];
    }
  }

  static List<ProfileSetup> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProfileSetup.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["age"] = age;
    _data["bio"] = bio;
    _data["height"] = height;
    _data["salary"] = salary;
    _data["user_id"] = userId;
    _data["education"] = education;
    _data["profession"] = profession;
    _data["salary_name"] = salaryName;
    _data["profile_url_1"] = profileUrl1;
    _data["profile_url_2"] = profileUrl2;
    _data["profile_url_3"] = profileUrl3;
    _data["profile_url_4"] = profileUrl4;
    _data["profile_url_5"] = profileUrl5;
    _data["work_location"] = workLocation;
    _data["education_name"] = educationName;
    _data["profession_name"] = professionName;
    _data["permanent_location"] = permanentLocation;
    return _data;
  }
}

class ProfileDetails {
  int? id;
  String? kul;
  int? caste;
  String? email;
  int? state;
  int? gender;
  int? zodiac;
  List<Hobbies>? hobbies;
  int? userId;
  int? district;
  String? fullname;
  int? religion;
  String? disablity;
  String? birthTime;
  String? casteName;
  String? stateName;
  String? birthPlace;
  int? bloodGroup;
  String? genderName;
  int? nationality;
  String? zodiacName;
  String? dateOfBirth;
  String? districtName;
  int? motherTongue;
  String? religionName;
  String? contactNumber;
  int? maritalStatus;
  String? bloodGroupName;
  String? nationalityName;
  String? motherTongueName;
  String? specificDisablity;
  String? maritalStatusName;

  ProfileDetails({this.id, this.kul, this.caste, this.email, this.state, this.gender, this.zodiac, this.hobbies, this.userId, this.district, this.fullname, this.religion, this.disablity, this.birthTime, this.casteName, this.stateName, this.birthPlace, this.bloodGroup, this.genderName, this.nationality, this.zodiacName, this.dateOfBirth, this.districtName, this.motherTongue, this.religionName, this.contactNumber, this.maritalStatus, this.bloodGroupName, this.nationalityName, this.motherTongueName, this.specificDisablity, this.maritalStatusName});

  ProfileDetails.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["kul"] is String) {
      kul = json["kul"];
    }
    if(json["caste"] is int) {
      caste = json["caste"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["state"] is int) {
      state = json["state"];
    }
    if(json["gender"] is int) {
      gender = json["gender"];
    }
    if(json["zodiac"] is int) {
      zodiac = json["zodiac"];
    }
    if(json["hobbies"] is List) {
      hobbies = json["hobbies"] == null ? null : (json["hobbies"] as List).map((e) => Hobbies.fromJson(e)).toList();
    }
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    if(json["district"] is int) {
      district = json["district"];
    }
    if(json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if(json["religion"] is int) {
      religion = json["religion"];
    }
    if(json["disablity"] is String) {
      disablity = json["disablity"];
    }
    if(json["birth_time"] is String) {
      birthTime = json["birth_time"];
    }
    if(json["caste_name"] is String) {
      casteName = json["caste_name"];
    }
    if(json["state_name"] is String) {
      stateName = json["state_name"];
    }
    if(json["birth_place"] is String) {
      birthPlace = json["birth_place"];
    }
    if(json["blood_group"] is int) {
      bloodGroup = json["blood_group"];
    }
    if(json["gender_name"] is String) {
      genderName = json["gender_name"];
    }
    if(json["nationality"] is int) {
      nationality = json["nationality"];
    }
    if(json["zodiac_name"] is String) {
      zodiacName = json["zodiac_name"];
    }
    if(json["date_of_birth"] is String) {
      dateOfBirth = json["date_of_birth"];
    }
    if(json["district_name"] is String) {
      districtName = json["district_name"];
    }
    if(json["mother_tongue"] is int) {
      motherTongue = json["mother_tongue"];
    }
    if(json["religion_name"] is String) {
      religionName = json["religion_name"];
    }
    if(json["contact_number"] is String) {
      contactNumber = json["contact_number"];
    }
    if(json["marital_status"] is int) {
      maritalStatus = json["marital_status"];
    }
    if(json["blood_group_name"] is String) {
      bloodGroupName = json["blood_group_name"];
    }
    if(json["nationality_name"] is String) {
      nationalityName = json["nationality_name"];
    }
    if(json["mother_tongue_name"] is String) {
      motherTongueName = json["mother_tongue_name"];
    }
    if(json["specific_disablity"] is String) {
      specificDisablity = json["specific_disablity"];
    }
    if(json["marital_status_name"] is String) {
      maritalStatusName = json["marital_status_name"];
    }
  }

  static List<ProfileDetails> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProfileDetails.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["kul"] = kul;
    _data["caste"] = caste;
    _data["email"] = email;
    _data["state"] = state;
    _data["gender"] = gender;
    _data["zodiac"] = zodiac;
    if(hobbies != null) {
      _data["hobbies"] = hobbies?.map((e) => e.toJson()).toList();
    }
    _data["user_id"] = userId;
    _data["district"] = district;
    _data["fullname"] = fullname;
    _data["religion"] = religion;
    _data["disablity"] = disablity;
    _data["birth_time"] = birthTime;
    _data["caste_name"] = casteName;
    _data["state_name"] = stateName;
    _data["birth_place"] = birthPlace;
    _data["blood_group"] = bloodGroup;
    _data["gender_name"] = genderName;
    _data["nationality"] = nationality;
    _data["zodiac_name"] = zodiacName;
    _data["date_of_birth"] = dateOfBirth;
    _data["district_name"] = districtName;
    _data["mother_tongue"] = motherTongue;
    _data["religion_name"] = religionName;
    _data["contact_number"] = contactNumber;
    _data["marital_status"] = maritalStatus;
    _data["blood_group_name"] = bloodGroupName;
    _data["nationality_name"] = nationalityName;
    _data["mother_tongue_name"] = motherTongueName;
    _data["specific_disablity"] = specificDisablity;
    _data["marital_status_name"] = maritalStatusName;
    return _data;
  }
}

class Hobbies {
  String? id;
  String? hobbyName;

  Hobbies({this.id, this.hobbyName});

  Hobbies.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["hobby_name"] is String) {
      hobbyName = json["hobby_name"];
    }
  }

  static List<Hobbies> fromList(List<Map<String, dynamic>> list) {
    return list.map(Hobbies.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["hobby_name"] = hobbyName;
    return _data;
  }
}