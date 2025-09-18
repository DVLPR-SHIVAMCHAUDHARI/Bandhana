class UserModel {
  String? mobileNumber;
  String? fullname;
  int? profileDetails;
  int? profileSetup;
  int? documentVerification;
  int? partnerExpectations;
  int? partnerLifeStyle;
  int? familyDetails;
  int? isDocumentVerification;
  String? xAuthToken;

  UserModel({
    this.mobileNumber,
    this.fullname,
    this.profileDetails,
    this.profileSetup,
    this.documentVerification,
    this.partnerExpectations,
    this.partnerLifeStyle,
    this.familyDetails,
    this.isDocumentVerification,
    this.xAuthToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json["mobile_number"] is String) {
      mobileNumber = json["mobile_number"];
    }
    if (json["fullname"] is String) {
      fullname = json["fullname"];
    }
    if (json["profile_details"] is int) {
      profileDetails = json["profile_details"];
    }
    if (json["profile_setup"] is int) {
      profileSetup = json["profile_setup"];
    }
    if (json["document_verification"] is int) {
      documentVerification = json["document_verification"];
    }
    if (json["partner_expectations"] is int) {
      partnerExpectations = json["partner_expectations"];
    }
    if (json["partner_life_style"] is int) {
      partnerLifeStyle = json["partner_life_style"];
    }
    if (json["family_details"] is int) {
      familyDetails = json["family_details"];
    }
    if (json["is_document_verification"] is int) {
      isDocumentVerification = json["is_document_verification"];
    }
    if (json["x_auth_token"] is String) {
      xAuthToken = json["x_auth_token"];
    }
  }

  static List<UserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["mobile_number"] = mobileNumber;
    data["fullname"] = fullname;
    data["profile_details"] = profileDetails;
    data["profile_setup"] = profileSetup;
    data["document_verification"] = documentVerification;
    data["partner_expectations"] = partnerExpectations;
    data["partner_life_style"] = partnerLifeStyle;
    data["family_details"] = familyDetails;
    data["is_document_verification"] = isDocumentVerification;
    data["x_auth_token"] = xAuthToken;
    return data;
  }
}
