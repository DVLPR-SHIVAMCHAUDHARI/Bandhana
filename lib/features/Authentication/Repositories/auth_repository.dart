import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/core/repository/repository.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';

import 'package:bandhana/core/services/tokenservice.dart';

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

        // 1️⃣ Store access token
        await token.storeTokens(accessToken: responseData['x_auth_token']);

        // 2️⃣ Save user to Hive
        await saveUserAfterOtp(responseData);

        return {"status": "success", "message": message};
      } else {
        return {"status": "failure", "message": message};
      }
    } catch (e, st) {
      logger.e("Error verifying OTP: $e\n$st");
      rethrow;
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
