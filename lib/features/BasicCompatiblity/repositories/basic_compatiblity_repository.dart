import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';
import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/core/repository/repository.dart';

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
        _updatePreferencesFlag();

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
        _updateLifestylePreferencesFlag();
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

/// Update local user model to mark preferences submitted
Future<void> _updateLifestylePreferencesFlag() async {
  final db = LocalDbService.instance;
  final currentUser = db.getUserData();

  if (currentUser != null) {
    final updatedUser = UserModel(
      mobileNumber: currentUser.mobileNumber,
      fullname: currentUser.fullname,
      profileDetails: currentUser.profileDetails,
      profileSetup: currentUser.profileSetup,
      documentVerification: currentUser.documentVerification,
      partnerExpectations: currentUser.partnerExpectations,
      partnerLifeStyle: 1,
      familyDetails: currentUser.familyDetails,

      // track submission
    );

    await db.saveUserData(updatedUser);
  }
}

/// Update local user model to mark preferences submitted
Future<void> _updatePreferencesFlag() async {
  final db = LocalDbService.instance;
  final currentUser = db.getUserData();

  if (currentUser != null) {
    final updatedUser = UserModel(
      mobileNumber: currentUser.mobileNumber,
      fullname: currentUser.fullname,
      profileDetails: currentUser.profileDetails,
      profileSetup: currentUser.profileSetup,
      documentVerification: currentUser.documentVerification,
      isDocumentVerification: 1,
      partnerLifeStyle: currentUser.partnerLifeStyle,
      familyDetails: currentUser.familyDetails,

      // track submission
    );

    await db.saveUserData(updatedUser);
  }
}

// }
