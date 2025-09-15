import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {}

class RegisterUserEvent extends RegistrationEvent {
  final String fullName;
  final int genderId;
  final int nationalityId;
  final int stateId;
  final int districtId;
  final String birthPlace;
  final int maritalStatusId;
  final String dateOfBirth;
  final int casteId;
  final int zodiacId;
  final String birthTime;
  final int religionId;
  final String contactNumber;
  final int motherTongueId;
  final String specificDisability;
  final int bloodGroupId;
  final String disability;
  final String email;
  final List hobbiesList;
  final String kul;

  RegisterUserEvent({
    required this.genderId,
    required this.fullName,
    required this.nationalityId,
    required this.stateId,
    required this.districtId,
    required this.birthPlace,
    required this.dateOfBirth,
    required this.birthTime,
    required this.zodiacId,
    required this.religionId,
    required this.casteId,
    required this.maritalStatusId,
    required this.contactNumber,
    required this.email,
    required this.hobbiesList,
    required this.motherTongueId,
    required this.bloodGroupId,
    required this.disability,
    required this.specificDisability,
    required this.kul,
  });

  @override
  List<Object?> get props => [];
}
