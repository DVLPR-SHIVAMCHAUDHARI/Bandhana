class ProfileSetupModel {
  int? id;
  int? age;
  String? bio;
  int? height;
  String? salary;
  int? userId;
  String? education;
  String? profession;
  String? profileUrl1;
  String? profileUrl2;
  String? profileUrl3;
  String? profileUrl4;
  String? profileUrl5;
  String? workLocation;
  String? permanentLocation;
  bool? error;
  String? code;

  ProfileSetupModel({
    this.id,
    this.age,
    this.bio,
    this.height,
    this.salary,
    this.userId,
    this.education,
    this.profession,
    this.profileUrl1,
    this.profileUrl2,
    this.profileUrl3,
    this.profileUrl4,
    this.profileUrl5,
    this.workLocation,
    this.permanentLocation,
    this.error,
    this.code,
  });

  ProfileSetupModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["age"] is int) {
      age = json["age"];
    }
    if (json["bio"] is String) {
      bio = json["bio"];
    }
    if (json["height"] is int) {
      height = json["height"];
    }
    if (json["salary"] is String) {
      salary = json["salary"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["education"] is String) {
      education = json["education"];
    }
    if (json["profession"] is String) {
      profession = json["profession"];
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
    if (json["permanent_location"] is String) {
      permanentLocation = json["permanent_location"];
    }
    if (json["error"] is bool) {
      error = json["error"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
  }

  static List<ProfileSetupModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProfileSetupModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["age"] = age;
    data["bio"] = bio;
    data["height"] = height;
    data["salary"] = salary;
    data["user_id"] = userId;
    data["education"] = education;
    data["profession"] = profession;
    data["profile_url_1"] = profileUrl1;
    data["profile_url_2"] = profileUrl2;
    data["profile_url_3"] = profileUrl3;
    data["profile_url_4"] = profileUrl4;
    data["profile_url_5"] = profileUrl5;
    data["work_location"] = workLocation;
    data["permanent_location"] = permanentLocation;
    data["error"] = error;
    data["code"] = code;
    return data;
  }
}
