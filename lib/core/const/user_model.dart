class UserModel {
  final String mobileNumber;
  final String fullname;
  final int profileDetails;
  final int profileSetup;
  final int documentVerification;
  final int partnerDetails;
  final int partnerLifeStyle;
  final int familyDetails;

  UserModel({
    required this.mobileNumber,
    required this.fullname,
    required this.profileDetails,
    required this.profileSetup,
    required this.documentVerification,
    required this.partnerDetails,
    required this.partnerLifeStyle,
    required this.familyDetails,
  });

  /// Factory: builds UserModel from API json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // If response has nested "user_data", pick that; otherwise use root
    final data = json['user_data'] is Map<String, dynamic>
        ? json['user_data']
        : json;

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return UserModel(
      mobileNumber: (data['mobile_number'] ?? '') as String,
      fullname: (data['fullname'] ?? '') as String,
      profileDetails: parseInt(data['profile_details']),
      profileSetup: parseInt(data['profile_setup']),
      documentVerification: parseInt(data['document_verification']),
      partnerDetails: parseInt(data['partner_details']),
      partnerLifeStyle: parseInt(data['partner_life_style']),
      familyDetails: parseInt(data['family_details']),
    );
  }

  /// Convert back to json for storage
  Map<String, dynamic> toJson() => {
    "mobile_number": mobileNumber,
    "fullname": fullname,
    "profile_details": profileDetails,
    "profile_setup": profileSetup,
    "document_verification": documentVerification,
    "partner_details": partnerDetails,
    "partner_life_style": partnerLifeStyle,
    "family_details": familyDetails,
  };
}
