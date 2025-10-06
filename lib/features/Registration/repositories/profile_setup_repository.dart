import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/repository/repository.dart';

class ProfileSetupRepository extends Repository {
  /// Submits profile data along with up to 5 images
  Future<Map<String, dynamic>> profileSetup({
    required String bio,
    required String age,
    required String height,
    required String education,
    required String profession,
    required String salary,
    required String permanentLocation,
    required String workLocation,
    List<XFile>? images, // pick XFiles directly
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        // ✅ dynamic
        "bio": bio,
        "age": age,
        "height": height,
        "education": education,
        "profession": profession,
        "salary": salary,
        "permanent_location": permanentLocation,
        "work_location": workLocation,
      };

      // Convert each XFile to MultipartFile
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length && i < 5; i++) {
          final image = images[i];
          formMap["profile_url_${i + 1}"] = await MultipartFile.fromFile(
            image.path,
            filename: image.name,
          );
        }
      }

      final formData = FormData.fromMap(formMap);

      final response = await dio.post("/profile/profile-setup", data: formData);

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
      return {"message": "An error occurred: $e", "status": "error"};
    }
  }
}
