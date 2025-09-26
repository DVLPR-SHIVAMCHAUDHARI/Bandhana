import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/core/repository/repository.dart';

class AuthRepository extends Repository {
  signUp({name, number}) async {
    try {
      final response = await dio.post(
        "/user/signup",
        data: {"fullname": "$name", "mobile_number": "$number"},
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
      rethrow;
    }
  }

  signIn({number}) async {
    try {
      final response = await dio.post(
        "/user/login",
        data: {"mobile_number": "$number"},
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
      rethrow;
    }
  }

  /// Verify OTP and store user + token
  Future<Map<String, String>> verifyOtp({
    required String number,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        "/user/verify-otp",
        data: {"mobile_number": number, "otp": otp},
      );

      final status = response.data['Response']['Status'];
      final statusCode = status['StatusCode'];
      final message = status['DisplayText'];

      if (statusCode == "0") {
        final responseData = response.data['Response']['ResponseData'];

        // Store access token
        await token.storeTokens(accessToken: responseData['x_auth_token']);

        // Save user in Hive
        await saveUserAfterOtp(
          UserModel(
            code: null,
            district: null,
            documentVerification: responseData["document_verification"],
            error: null,
            familyDetails: responseData["family_details"],
            fullname: responseData['fullname'],
            isDocumentVerification: responseData["is_document_verification"],
            mobileNumber: responseData['mobile_number'],
            partnerExpectations: responseData['partner_expectations'],
            partnerLifeStyle: responseData['partner_life_style'],
            paymentDone: null,
            profileDetails: responseData['profile_details'],
            profileSetup: responseData['profile_setup'],
            profileUrl1: null,
            userId: null,
          ),
        );

        return {"status": "success", "message": message};
      } else {
        return {"status": "failure", "message": message};
      }
    } catch (e, st) {
      logger.e("Error verifying OTP: $e\n$st");
      return {"status": "failure", "message": "Something went wrong"};
    }
  }

  /// Save user after OTP verification
  Future<void> saveUserAfterOtp(response) async {
    print("📦 UserModel created: $response");

    // Save user to Hive
    await localDb.saveUserData(response);

    // Optional: print saved data for debugging
    final savedUser = localDb.getUserData();
    print("✅ Saved user in Hive: ${savedUser?.toJson()}");
  }

  reSendOtp({number, otp}) async {
    try {
      final response = await dio.post(
        "/user/resend-otp",
        data: {"mobile_number": "$number"},
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
      rethrow;
    }
  }
}
