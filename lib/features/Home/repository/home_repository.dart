import 'package:bandhana/core/repository/repository.dart';
import 'package:bandhana/features/Home/models/home_user_model.dart';

class HomeRepository extends Repository {
  Future<Map<String, dynamic>> getUserList() async {
    try {
      var response = await dio.get("/matched/home-landing");
      if (response.data["Response"]["Status"]["StatusCode"] == "0") {
        final List<dynamic> list =
            response.data["Response"]["ResponseData"]["list"];
        final users = list.map((e) => HomeUserModel.fromJson(e)).toList();

        return {
          "status": "Success",
          "response": users, // ✅ Already typed list
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
