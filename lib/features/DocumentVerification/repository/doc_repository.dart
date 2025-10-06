import 'dart:io';
import 'package:dio/dio.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/repository/repository.dart';

class DocRepository extends Repository {
  Future<Map<String, dynamic>> docUpload({
    required String aadhaar_or_pan,
    required String caste_certificte,
    File? aadhaar_or_pan_url,
    File? live_selfie_url,
    File? caste_certificte_url,
    File? selfie_with_id_url,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        "aadhaar_or_pan": aadhaar_or_pan,
        "caste_certificte": caste_certificte,
        if (aadhaar_or_pan_url != null)
          "aadhaar_or_pan_url": await MultipartFile.fromFile(
            aadhaar_or_pan_url.path,
          ),
        if (live_selfie_url != null)
          "live_selfie_url": await MultipartFile.fromFile(live_selfie_url.path),
        if (caste_certificte_url != null)
          "caste_certificte_url": await MultipartFile.fromFile(
            caste_certificte_url.path,
          ),
        if (selfie_with_id_url != null)
          "selfie_with_id_url": await MultipartFile.fromFile(
            selfie_with_id_url.path,
          ),
      };

      final formData = FormData.fromMap(formMap);

      final response = await dio.post(
        "/profile/profile-document",
        data: formData,
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
      return {"message": "An error occurred: $e", "status": "error"};
    }
  }
}
