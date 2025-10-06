class AboutModel {
  final String statement1;
  final String statement2;
  final String statement3;
  final String statement4;
  final String mobileNo;
  final String email;

  AboutModel({
    required this.statement1,
    required this.statement2,
    required this.statement3,
    required this.statement4,
    required this.mobileNo,
    required this.email,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      statement1: json['statement_1'] ?? '',
      statement2: json['statement_2'] ?? '',
      statement3: json['statement_3'] ?? '',
      statement4: json['statement_4'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
