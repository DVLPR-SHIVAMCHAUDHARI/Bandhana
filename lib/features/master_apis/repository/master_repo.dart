import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/user_model.dart';
import 'package:MilanMandap/core/repository/repository.dart';
import 'package:MilanMandap/features/Home/models/home_user_model.dart';

class MasterRepo extends Repository {
  // Nationality
  Future<Map<String, dynamic>> getNationality() async {
    return _fetchMasterData(
      endpoint: "/common/get-nationality",
      key: "mst_nationality",
    );
  }

  // State
  Future<Map<String, dynamic>> getStates(index) async {
    return _fetchMasterData(
      endpoint: "/common/states/$index",
      key: "mst_state",
    );
  }

  // District
  Future<Map<String, dynamic>> getDistricts(stateId) async {
    return _fetchMasterData(
      endpoint: "/common/district/$stateId",
      key: "mst_district",
    );
  }

  // Zodiac
  Future<Map<String, dynamic>> getZodiac() async {
    return _fetchMasterData(endpoint: "/common/zodiac", key: "mst_zodiac");
  }

  // Gender
  Future<Map<String, dynamic>> getGender() async {
    return _fetchMasterData(endpoint: "/common/gender", key: "mst_gender");
  }

  // Religion
  Future<Map<String, dynamic>> getReligion() async {
    return _fetchMasterData(endpoint: "/common/religion", key: "mst_religion");
  }

  // Caste
  Future<Map<String, dynamic>> getCaste(religionId) async {
    return _fetchMasterData(
      endpoint: "/common/caste/$religionId",
      key: "mst_caste",
    );
  }

  // Marital Status
  Future<Map<String, dynamic>> getMaritalStatus() async {
    return _fetchMasterData(
      endpoint: "/common/marital-status",
      key: "mst_marital_status",
    );
  }

  // Mother Tongue
  Future<Map<String, dynamic>> getMotherTongue() async {
    return _fetchMasterData(
      endpoint: "/common/mother-tongue",
      key: "mst_mother_tongue",
    );
  }

  // Blood Group
  Future<Map<String, dynamic>> getBloodGroup() async {
    return _fetchMasterData(
      endpoint: "/common/blood-group",
      key: "mst_blood_group",
    );
  }

  // Education
  Future<Map<String, dynamic>> getEducation() async {
    return _fetchMasterData(
      endpoint: "/common/education",
      key: "mst_education",
    );
  }

  // Profession
  Future<Map<String, dynamic>> getProfession() async {
    return _fetchMasterData(
      endpoint: "/common/profession",
      key: "mst_profession",
    );
  }

  // Hobbies
  Future<Map<String, dynamic>> getHobbies() async {
    return _fetchMasterData(endpoint: "/common/hobbies", key: "mst_hobby");
  }

  // Salary
  Future<Map<String, dynamic>> getSalary() async {
    return _fetchMasterData(
      endpoint: "/common/salary-range",
      key: "mst_salary_range",
    );
  }

  // familytype
  Future<Map<String, dynamic>> getFamilyType() async {
    return _fetchMasterData(
      endpoint: "/common/family-type",
      key: "mst_family_type",
    );
  }

  // familystatus
  Future<Map<String, dynamic>> getFamilyStatus() async {
    return _fetchMasterData(
      endpoint: "/common/family-status",
      key: "mst_family_status",
    );
  }

  // familyvalues
  Future<Map<String, dynamic>> getFamilyValues() async {
    return _fetchMasterData(
      endpoint: "/common/family-values",
      key: "mst_family_values",
    );
  }

  // 🔥 Private reusable function
  Future<Map<String, dynamic>> _fetchMasterData({
    required String endpoint,
    required String key,
  }) async {
    try {
      final response = await dio.get(endpoint);

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {
          "list": response.data['Response']['ResponseData'][key],
          "status": "success",
        };
      } else {
        return {
          "message": response.data['Response']['Status']['DisplayText'],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e("❌ Error fetching $key: $e");
      return {"message": e.toString(), "status": "error"};
    }
  }

  getProfileDetail() async {
    try {
      var response = await dio.get("/profile/get-profile-details");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getProfileSetup() async {
    try {
      var response = await dio.get("/profile/get-profile-setup");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getFamilyDetails() async {
    try {
      var response = await dio.get("/profile/get-family-details");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getBasicCompablity1() async {
    try {
      var response = await dio.get("/profile/get-partner-expectations");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getLifestylePreferences() async {
    try {
      var response = await dio.get(
        "/profile/get-partner-lifestyle-preferences",
      );

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getYourDetail() async {
    try {
      var response = await dio.get("/matched/self-user-details");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  getProfileStatus() async {
    try {
      var response = await dio.post("/user/profile-status");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        saveUserAfterOtp(response.data["Response"]["ResponseData"]);
        return {
          "response": response.data["Response"]["ResponseData"],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<bool> toggleFavorite(String userId, {bool add = true}) async {
    final endpoint = add ? '/matched/add-favorite' : '/matched/remove-favorite';

    final response = await dio.post(
      endpoint,
      queryParameters: {"user_id": userId},
    );

    final status = response.data['Response']?['Status'];
    if (status != null && status['DisplayText'] == 'Success') {
      return add; // return current favorite state
    } else {
      final msg =
          response.data['Response']?['Status']?['ErrorMessage'] ??
          'Failed to toggle favorite';
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> getFavoriteList() async {
    try {
      final response = await dio.get("/matched/get-favorite");

      final status = response.data["Response"]?["Status"];
      if (status != null && status["StatusCode"] == "0") {
        final List<dynamic> list =
            response.data["Response"]?["ResponseData"]?["list"] ?? [];

        final users = list.map((e) => HomeUserModel.fromJson(e)).toList();

        return {
          "status": "Success",
          "response": users, // ✅ Already typed list
        };
      } else {
        return {
          "status": "Failure",
          "response": status?["DisplayText"] ?? "Failed to fetch favorites",
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  skipProfile({id}) async {
    try {
      var response = await dio.post(
        "/matched/skip-profile",
        queryParameters: {"user_id": id},
      );

      final statusCode = response.data["Response"]["Status"]["StatusCode"];
      final displayText =
          response.data["Response"]["Status"]["DisplayText"] ??
          "Unknown response";

      if (statusCode == "0") {
        return {"response": displayText, "status": "Success"};
      } else {
        return {"response": displayText, "status": "failure"};
      }
    } catch (e) {
      return {"response": e.toString(), "status": "failure"};
    }
  }
}

/// Save user after OTP verification
Future<void> saveUserAfterOtp(Map<String, dynamic> response) async {
  // Convert API response to UserModel
  final userModel = UserModel.fromJson(response);
  print("📦 UserModel created: $userModel");

  // Save user to Hive
  await localDb.saveUserData(userModel);

  // Optional: print saved data for debugging
  final savedUser = localDb.getUserData();
  print("✅ Saved user in Hive: ${savedUser?.toJson()}");
}
