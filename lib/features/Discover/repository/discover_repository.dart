import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/repository/repository.dart';

class DiscoverRepository extends Repository {
  getUsers() async {
    try {
      // var response = await dio.post("/profile/get-profile-details");

      // if (response.data["Response"]["Status"]["StatusCode"] == "0") {}
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
