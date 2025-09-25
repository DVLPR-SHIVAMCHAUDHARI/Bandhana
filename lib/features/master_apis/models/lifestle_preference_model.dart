class LifestylePreferenceModel {
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
  bool? error;
  String? code;

  LifestylePreferenceModel({
    this.id,
    this.diet,
    this.userId,
    this.petFriendly,
    this.dailyRoutine,
    this.sleepPattern,
    this.smokingHabit,
    this.drinkingHabit,
    this.fitnessActivity,
    this.travelPreferences,
    this.error,
    this.code,
  });

  LifestylePreferenceModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["diet"] is String) {
      diet = json["diet"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["pet_friendly"] is String) {
      petFriendly = json["pet_friendly"];
    }
    if (json["daily_routine"] is String) {
      dailyRoutine = json["daily_routine"];
    }
    if (json["sleep_pattern"] is String) {
      sleepPattern = json["sleep_pattern"];
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
    if (json["travel_preferences"] is String) {
      travelPreferences = json["travel_preferences"];
    }
    if (json["error"] is bool) {
      error = json["error"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
  }

  static List<LifestylePreferenceModel> fromList(
    List<Map<String, dynamic>> list,
  ) {
    return list.map(LifestylePreferenceModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["diet"] = diet;
    data["user_id"] = userId;
    data["pet_friendly"] = petFriendly;
    data["daily_routine"] = dailyRoutine;
    data["sleep_pattern"] = sleepPattern;
    data["smoking_habit"] = smokingHabit;
    data["drinking_habit"] = drinkingHabit;
    data["fitness_activity"] = fitnessActivity;
    data["travel_preferences"] = travelPreferences;
    data["error"] = error;
    data["code"] = code;
    return data;
  }
}
