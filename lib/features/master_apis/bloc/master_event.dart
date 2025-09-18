import 'package:equatable/equatable.dart';

abstract class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object?> get props => [];
}

/// Nationality
class GetNationalityEvent extends MasterEvent {}

/// State
class GetStateEvent extends MasterEvent {
  final int nationalityId;
  const GetStateEvent(this.nationalityId);

  @override
  List<Object?> get props => [nationalityId];
}

/// District
class GetDistrictEvent extends MasterEvent {
  final int stateId;
  const GetDistrictEvent(this.stateId);

  @override
  List<Object?> get props => [stateId];
}

/// Zodiac
class GetZodiacEvent extends MasterEvent {}

/// Gender
class GetGenderEvent extends MasterEvent {}

/// Religion
class GetReligionEvent extends MasterEvent {}

/// Caste
class GetCasteEvent extends MasterEvent {
  final int religionId;
  const GetCasteEvent(this.religionId);

  @override
  List<Object?> get props => [religionId];
}

/// Marital Status
class GetMaritalStatusEvent extends MasterEvent {}

/// Mother Tongue
class GetMotherTongueEvent extends MasterEvent {}

/// Blood Group
class GetBloodGroupEvent extends MasterEvent {}

/// Education
class GetEducationEvent extends MasterEvent {}

/// Profession
class GetProfessionEvent extends MasterEvent {}

/// Hobbies
class GetHobbiesEvent extends MasterEvent {}

//salary
class GetSalaryEvent extends MasterEvent {}

//familytype
class GetFamilyTypeEvent extends MasterEvent {}

//familyvalue
class GetFamilyValuesEvent extends MasterEvent {}

//familyStatus
class GetFamilyStatusEvent extends MasterEvent {}

//profileDetails
class GetProfileDetailsEvent extends MasterEvent {}

//profileSetup
class GetProfileSetupEvent extends MasterEvent {}
