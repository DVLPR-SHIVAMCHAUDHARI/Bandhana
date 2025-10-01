class HomeUserModel {
  int? userId;
  int? matchPercentage;
  int? patnerLifeStyle;
  String? fullname;
  String? gender;
  String? nationality;
  String? state;
  String? district;
  String? birthPlace;
  String? dateOfBirth;
  String? birthTime;
  String? zodiac;
  String? religion;
  String? caste;
  String? maritalStatus;
  String? motherTongue;
  List<Hobbies>? hobbies;
  String? education;
  String? profession;
  String? bio;
  int? age;
  int? height;
  String? profileUrl1;
  String? profileUrl2;
  String? profileUrl3;
  String? profileUrl4;
  String? profileUrl5;
  String? workLocation;
  String? dite;
  String? smokingHabit;
  String? drinkingHabit;
  String? fitnessActivity;
  String? sleepPattern;
  String? travelPreferences;
  String? petFriendly;
  String? dailyRoutine;
  int? isFavorite;

  HomeUserModel({
    this.isFavorite,
    this.userId,
    this.matchPercentage,
    this.patnerLifeStyle,
    this.fullname,
    this.gender,
    this.nationality,
    this.state,
    this.district,
    this.birthPlace,
    this.dateOfBirth,
    this.birthTime,
    this.zodiac,
    this.religion,
    this.caste,
    this.maritalStatus,
    this.motherTongue,
    this.hobbies,
    this.education,
    this.profession,
    this.bio,
    this.age,
    this.height,
    this.profileUrl1,
    this.profileUrl2,
    this.profileUrl3,
    this.profileUrl4,
    this.profileUrl5,
    this.workLocation,
    this.dite,
    this.smokingHabit,
    this.drinkingHabit,
    this.fitnessActivity,
    this.sleepPattern,
    this.travelPreferences,
    this.petFriendly,
    this.dailyRoutine,
  });

  HomeUserModel.fromJson(Map<String, dynamic> json) {
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["is_favorite"] is int) {
      isFavorite = json["is_favorite"];
    }
    if (json["match_percentage"] is int) {
      matchPercentage = json["match_percentage"];
    }
    if (json["patner_life_style"] is int) {
      patnerLifeStyle = json["patner_life_style"];
    }
    if (json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if (json["gender"] is String) {
      gender = json["gender"];
    }
    if (json["nationality"] is String) {
      nationality = json["nationality"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["district"] is String) {
      district = json["district"];
    }
    if (json["birth_place"] is String) {
      birthPlace = json["birth_place"];
    }
    if (json["date_of_birth"] is String) {
      dateOfBirth = json["date_of_birth"];
    }
    if (json["birth_time"] is String) {
      birthTime = json["birth_time"];
    }
    if (json["zodiac"] is String) {
      zodiac = json["zodiac"];
    }
    if (json["religion"] is String) {
      religion = json["religion"];
    }
    if (json["caste"] is String) {
      caste = json["caste"];
    }
    if (json["marital_status"] is String) {
      maritalStatus = json["marital_status"];
    }
    if (json["mother_tongue"] is String) {
      motherTongue = json["mother_tongue"];
    }
    if (json["hobbies"] is List) {
      hobbies = json["hobbies"] == null
          ? null
          : (json["hobbies"] as List).map((e) => Hobbies.fromJson(e)).toList();
    }
    if (json["education"] is String) {
      education = json["education"];
    }
    if (json["profession"] is String) {
      profession = json["profession"];
    }
    if (json["bio"] is String) {
      bio = json["bio"];
    }
    if (json["age"] is int) {
      age = json["age"];
    }
    if (json["height"] is int) {
      height = json["height"];
    }
    if (json["profile_url_1"] is String) {
      profileUrl1 = json["profile_url_1"];
    }
    if (json["profile_url_2"] is String) {
      profileUrl2 = json["profile_url_2"];
    }
    if (json["profile_url_3"] is String) {
      profileUrl3 = json["profile_url_3"];
    }
    if (json["profile_url_4"] is String) {
      profileUrl4 = json["profile_url_4"];
    }
    if (json["profile_url_5"] is String) {
      profileUrl5 = json["profile_url_5"];
    }
    if (json["work_location"] is String) {
      workLocation = json["work_location"];
    }
    if (json["dite"] is String) {
      dite = json["dite"];
    }
    if (json["smoking_habit"] is String) {
      smokingHabit = json["smoking_habit"];
    }
    if (json["drinking_habit"] is String) {
      drinkingHabit = json["drinking_habit"];
    }
    if (json["fitness_activity"] is String) {
      fitnessActivity = json["fitness_activity"];
    }
    if (json["sleep_pattern"] is String) {
      sleepPattern = json["sleep_pattern"];
    }
    if (json["travel_preferences"] is String) {
      travelPreferences = json["travel_preferences"];
    }
    if (json["pet_friendly"] is String) {
      petFriendly = json["pet_friendly"];
    }
    if (json["daily_routine"] is String) {
      dailyRoutine = json["daily_routine"];
    }
  }

  static List<HomeUserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(HomeUserModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["user_id"] = userId;
    data["is_favorite"] = isFavorite;
    data["match_percentage"] = matchPercentage;
    data["patner_life_style"] = patnerLifeStyle;
    data["fullname"] = fullname;
    data["gender"] = gender;
    data["nationality"] = nationality;
    data["state"] = state;
    data["district"] = district;
    data["birth_place"] = birthPlace;
    data["date_of_birth"] = dateOfBirth;
    data["birth_time"] = birthTime;
    data["zodiac"] = zodiac;
    data["religion"] = religion;
    data["caste"] = caste;
    data["marital_status"] = maritalStatus;
    data["mother_tongue"] = motherTongue;
    if (hobbies != null) {
      data["hobbies"] = hobbies?.map((e) => e.toJson()).toList();
    }
    data["education"] = education;
    data["profession"] = profession;
    data["bio"] = bio;
    data["age"] = age;
    data["height"] = height;
    data["profile_url_1"] = profileUrl1;
    data["profile_url_2"] = profileUrl2;
    data["profile_url_3"] = profileUrl3;
    data["profile_url_4"] = profileUrl4;
    data["profile_url_5"] = profileUrl5;
    data["work_location"] = workLocation;
    data["dite"] = dite;
    data["smoking_habit"] = smokingHabit;
    data["drinking_habit"] = drinkingHabit;
    data["fitness_activity"] = fitnessActivity;
    data["sleep_pattern"] = sleepPattern;
    data["travel_preferences"] = travelPreferences;
    data["pet_friendly"] = petFriendly;
    data["daily_routine"] = dailyRoutine;
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
