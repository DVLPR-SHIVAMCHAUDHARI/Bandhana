import 'package:MilanMandap/core/repository/repository.dart';

class AboutInfoRepo extends Repository {
  Future<Map<String, dynamic>> getUserList() async {
    try {
      var response = await dio.get("/common/about-us");
      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        final data =
            response.data["Response"]["ResponseData"]["mst_lifestyle"][0];

        return {
          "status": "Success",
          "response": data, // ✅ Already typed list
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
}
