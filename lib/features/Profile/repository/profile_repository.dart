import 'package:bandhana/core/repository/repository.dart';

import 'package:bandhana/features/Profile/model/user_detail_model.dart';

class ProfileRepository extends Repository {
  Future<Map<String, dynamic>> getUserById({id}) async {
    try {
      var response = await dio.get(
        "/matched/user-details",
        queryParameters: {"user_id": id},
      );

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        final Map<String, dynamic> userJson =
            response.data["Response"]["ResponseData"];
        final UserDetailModel userDetails = UserDetailModel.fromJson(userJson);

        return {"status": "Success", "response": userDetails};
      } else {
        return {
          "status": "Failure",
          "response": response.data["Response"]["Status"]["DisplayText"],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendRequest({id}) async {
    try {
      var response = await dio.post(
        "/matched/send-request",
        queryParameters: {"user_id": id},
      );

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "status": "Success",
          "response": response.data["Response"]["Status"]["DisplayText"],
        };
      } else {
        return {
          "status": "Failure",
          "response": response.data["Response"]["Status"]["DisplayText"],
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptRequest({id}) async {
    try {
      var response = await dio.post(
        "/matched/accept-request",
        queryParameters: {"user_id": id},
      );

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "status": "Success",
          "response":
              response.data["Response"]["Status"]["DisplayText"] ?? "Success",
        };
      } else {
        return {
          "status": "Failure",
          "response":
              response.data["Response"]["Status"]["DisplayText"] ?? "Failed",
        };
      }
    } catch (e) {
      rethrow;
    }
  }
}
