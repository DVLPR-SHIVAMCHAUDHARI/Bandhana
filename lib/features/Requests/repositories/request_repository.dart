import 'package:bandhana/core/repository/repository.dart';

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
}
