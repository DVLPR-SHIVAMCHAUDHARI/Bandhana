
class UserModel {
  int? userId;
  dynamic district;
  String? fullname;
  int? paymentDone;
  String? mobileNumber;
  int? profileSetup;
  dynamic profileUrl1;
  int? familyDetails;
  int? profileDetails;
  int? partnerLifeStyle;
  int? partnerExpectations;
  int? documentVerification;
  int? isDocumentVerification;
  bool? error;
  String? code;

  UserModel({this.userId, this.district, this.fullname, this.paymentDone, this.mobileNumber, this.profileSetup, this.profileUrl1, this.familyDetails, this.profileDetails, this.partnerLifeStyle, this.partnerExpectations, this.documentVerification, this.isDocumentVerification, this.error, this.code});

  UserModel.fromJson(Map<String, dynamic> json) {
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
    district = json["district"];
    if(json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if(json["payment_done"] is int) {
      paymentDone = json["payment_done"];
    }
    if(json["mobile_number"] is String) {
      mobileNumber = json["mobile_number"];
    }
    if(json["profile_setup"] is int) {
      profileSetup = json["profile_setup"];
    }
    profileUrl1 = json["profile_url_1"];
    if(json["family_details"] is int) {
      familyDetails = json["family_details"];
    }
    if(json["profile_details"] is int) {
      profileDetails = json["profile_details"];
    }
    if(json["partner_life_style"] is int) {
      partnerLifeStyle = json["partner_life_style"];
    }
    if(json["partner_expectations"] is int) {
      partnerExpectations = json["partner_expectations"];
    }
    if(json["document_verification"] is int) {
      documentVerification = json["document_verification"];
    }
    if(json["is_document_verification"] is int) {
      isDocumentVerification = json["is_document_verification"];
    }
    if(json["error"] is bool) {
      error = json["error"];
    }
    if(json["code"] is String) {
      code = json["code"];
    }
  }

  static List<UserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["user_id"] = userId;
    _data["district"] = district;
    _data["fullname"] = fullname;
    _data["payment_done"] = paymentDone;
    _data["mobile_number"] = mobileNumber;
    _data["profile_setup"] = profileSetup;
    _data["profile_url_1"] = profileUrl1;
    _data["family_details"] = familyDetails;
    _data["profile_details"] = profileDetails;
    _data["partner_life_style"] = partnerLifeStyle;
    _data["partner_expectations"] = partnerExpectations;
    _data["document_verification"] = documentVerification;
    _data["is_document_verification"] = isDocumentVerification;
    _data["error"] = error;
    _data["code"] = code;
    return _data;
  }
}