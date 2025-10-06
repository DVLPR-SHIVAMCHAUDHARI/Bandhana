import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/repository/repository.dart';

class UserPreferencesRepository extends Repository {
  /// Submit user preferences like age range, height, education, profession, etc.
  Future<Map<String, dynamic>> submitPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await dio.post(
        "/profile/partner-expectations",
        data: preferences,
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {
          "message": response.data['Response']['Status']['DisplayText'],
          "status": "success",
        };
      } else {
        return {
          "message": response.data['Response']['Status']['DisplayText'],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      return {"message": "An error occurred: $e", "status": "error"};
    }
  }

  Future<Map<String, dynamic>> submitLifestylePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      final response = await dio.post(
        "/profile/partner-lifestyle-preferences",
        data: preferences,
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        return {
          "message": response.data['Response']['Status']['DisplayText'],
          "status": "success",
        };
      } else {
        return {
          "message": response.data['Response']['Status']['DisplayText'],
          "status": "failure",
        };
      }
    } catch (e) {
      logger.e(e);
      return {"message": "An error occurred: $e", "status": "error"};
    }
  }
}
