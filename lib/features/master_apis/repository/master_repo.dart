import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/repository/repository.dart';

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
}
