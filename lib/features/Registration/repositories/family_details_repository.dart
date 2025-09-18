import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/core/repository/repository.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';
import 'package:dio/dio.dart';

class FamilyDetailRepository extends Repository {
  Future<Map<String, dynamic>> submitFamilyDetail({
    required String fathersName,
    required String fathersOccupation,
    required String fathersContact,
    required String mothersName,
    required String mothersOccupation,
    required String mothersContact,
    required String noOfBrothers,
    required String noOfSisters,
    required String familyType,
    required String familyStatus,
    required String familyValues,
    required String maternalUncleMamasName,
    required String maternalUncleMamasVillage,
    required String mamasKulClan,
    required String relativesFamilySurnames,
  }) async {
    try {
      final formData = FormData.fromMap({
        "fathers_name": fathersName,
        "fathers_occupation": fathersOccupation,
        "fathers_contact": fathersContact,
        "mothers_name": mothersName,
        "mothers_occupation": mothersOccupation,
        "mothers_contact": mothersContact,
        "no_of_brothers": noOfBrothers,
        "no_of_sisters": noOfSisters,
        "family_type": familyType,
        "family_status": familyStatus,
        "family_values": familyValues,
        "maternal_uncle_mamas_name": maternalUncleMamasName,
        "maternal_uncle_mamas_village": maternalUncleMamasVillage,
        "mamas_kul_clan": mamasKulClan,
        "relatives_family_surnames": relativesFamilySurnames,
      });

      final response = await dio.post(
        "/profile/family-details",
        data: formData,
      );

      if (response.data['Response']['Status']['StatusCode'] == "0") {
        updateFamilyDetailsFlag();
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
      return {"message": "Error occurred: $e", "status": "error"};
    }
  }
}

Future<void> updateFamilyDetailsFlag() async {
  final db = LocalDbService.instance;

  // get current user
  final currentUser = db.getUserData();

  // create updated user with familyDetails = 1
  final updatedUser = UserModel(
    mobileNumber: currentUser!.mobileNumber,
    fullname: currentUser.fullname,
    profileDetails: currentUser.profileDetails,
    profileSetup: currentUser.profileSetup,
    documentVerification: currentUser.documentVerification,
    partnerExpectations: currentUser.partnerExpectations,

    partnerLifeStyle: currentUser.partnerLifeStyle,
    familyDetails: 1, // ✅ update this
  );

  // save back to Hive
  await db.saveUserData(updatedUser);
}
