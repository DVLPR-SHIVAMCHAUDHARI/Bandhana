import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/core/repository/repository.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';

class RegistrationRepository extends Repository {
  registerUser({
    required fullName,
    required genderId,
    required nationalityId,
    required stateId,
    required districtId,
    required birthPlace,
    required dateOfBirth,
    required birthTime,
    required zodiacId,
    required religionId,
    required casteId,
    required maritalStatusId,
    contactNumber,
    email,
    required hobbiesList,
    required motherTongueId,
    required bloodGroupId,
    required disability,
    required specificDisability,
    required kul,
  }) async {
    try {
      final response = await dio.post(
        "/profile/profile-details",
        data: {
          "fullname": "$fullName",
          "gender": genderId,
          "nationality": nationalityId,
          "state": stateId,
          "district": districtId,
          "birth_place": "$birthPlace",
          "date_of_birth": "$dateOfBirth",
          "birth_time": "$birthTime",
          "zodiac": zodiacId,
          "religion": religionId,
          "caste": casteId,
          "marital_status": maritalStatusId,
          "contact_number": "$contactNumber",
          "email": "$email",
          "hobbies": hobbiesList,
          "mother_tongue": motherTongueId,
          "blood_group": bloodGroupId,
          "disablity": disability,
          "specific_disablity": "$specificDisability",
          "kul": "$kul",
        },
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
      throw Exception('Error in registration: $e');
    }
  }

  submitFamilyDetails({
    fathersName,
    mothersName,
    fathersOccupation,
    mothersOccupation,
    numberOfSisters,
    numberOfBrothers,
    familyType,
    familyStatus,
    familyValues,
  }) async {
    try {
      final response = await dio.post(
        "/profile/family-details",
        data: {
          "fullname": "Ajaykumar Vishwakarma",
          "gender": 1,
          "nationality": 2,
          "state": 2,
          "district": 3,
          "birth_place": "Nashik",
          "date_of_birth": "1999-06-29",
          "birth_time": "05:30",
          "zodiac": 1,
          "religion": 1,
          "caste": 32,
          "marital_status": 1,
          "contact_number": "+918758475984",
          "email": "",
          "hobbies": [1, 2, 3, 5, 6],
          "mother_tongue": 6,
          "blood_group": 7,
          "disablity": "No",
          "specific_disablity": "",
          "kul": "ABC",
        },
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
      throw Exception('Error in submitting family details: $e');
    }
  }
}
