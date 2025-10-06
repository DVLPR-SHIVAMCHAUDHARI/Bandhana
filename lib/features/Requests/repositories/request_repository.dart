import 'package:MilanMandap/core/repository/repository.dart';

class RequestRepository extends Repository {
  getRecievedRequests() async {
    try {
      var response = await dio.get("/matched/get-request-list");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"]['list'],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  getSentRequests() async {
    try {
      var response = await dio.get("/matched/get-send-list");

      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        return {
          "response": response.data["Response"]["ResponseData"]['list'],
          "status": "Success",
        };
      } else {
        return {
          "response": response.data["Response"]["status"]["DisplayText"],
          "status": "failure",
        };
      }
    } catch (e) {
      rethrow;
    }
  }

  rejectRecivedRequest({id}) async {
    try {
      var response = await dio.post(
        "/matched/reject-request",
        queryParameters: {"user_id": id},
      );

      final statusCode = response.data["Response"]["Status"]["StatusCode"];
      final displayText =
          response.data["Response"]["Status"]["DisplayText"] ??
          "Unknown response";

      if (statusCode == "0") {
        return {
          "response": displayText, // Always a String
          "status": "Success",
        };
      } else {
        return {"response": displayText, "status": "failure"};
      }
    } catch (e) {
      return {"response": e.toString(), "status": "failure"};
    }
  }
}
