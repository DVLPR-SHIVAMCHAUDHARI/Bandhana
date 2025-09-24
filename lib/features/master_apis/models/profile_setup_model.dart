class ProfileSetupModel {
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
    this.salaryName,
    this.profileUrl1,
    this.profileUrl2,
    this.profileUrl3,
    this.profileUrl4,
    this.profileUrl5,
    this.workLocation,
    this.educationName,
    this.professionName,
    this.permanentLocation,
    this.error,
    this.code,
  });

  factory ProfileSetupModel.fromJson(Map<String, dynamic> json) {
    return ProfileSetupModel(
      id: json['id'] as int?,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      height: json['height'] as int?,
      salary: json['salary'] as int?,
      userId: json['user_id'] as int?,
      education: json['education'] as int?,
      profession: json['profession'] as int?,
      salaryName: json['salary_name'] as String?,
      profileUrl1: json['profile_url_1'] as String?,
      profileUrl2: json['profile_url_2'] as String?,
      profileUrl3: json['profile_url_3'] as String?,
      profileUrl4: json['profile_url_4'] as String?,
      profileUrl5: json['profile_url_5'] as String?,
      workLocation: json['work_location'] as String?,
      educationName: json['education_name'] as String?,
      professionName: json['profession_name'] as String?,
      permanentLocation: json['permanent_location'] as String?,
      error: json['error'] as bool?,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'bio': bio,
      'height': height,
      'salary': salary,
      'user_id': userId,
      'education': education,
      'profession': profession,
      'salary_name': salaryName,
      'profile_url_1': profileUrl1,
      'profile_url_2': profileUrl2,
      'profile_url_3': profileUrl3,
      'profile_url_4': profileUrl4,
      'profile_url_5': profileUrl5,
      'work_location': workLocation,
      'education_name': educationName,
      'profession_name': professionName,
      'permanent_location': permanentLocation,
      'error': error,
      'code': code,
    };
  }
}
