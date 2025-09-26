import 'package:bandhana/features/master_apis/models/basic_compatiblity_model.dart';
import 'package:bandhana/features/master_apis/models/district_model.dart';
import 'package:bandhana/features/master_apis/models/family_details_model.dart';
import 'package:bandhana/features/master_apis/models/family_status_model.dart';
import 'package:bandhana/features/master_apis/models/family_type_model.dart';
import 'package:bandhana/features/master_apis/models/family_values_model.dart';
import 'package:bandhana/features/master_apis/models/gender_model.dart';
import 'package:bandhana/features/master_apis/models/lifestle_preference_model.dart';
import 'package:bandhana/features/master_apis/models/nationality_model.dart';
import 'package:bandhana/features/master_apis/models/profile_setup_model.dart';
import 'package:bandhana/features/master_apis/models/salary_model.dart';
import 'package:bandhana/features/master_apis/models/state_model.dart';
import 'package:bandhana/features/master_apis/models/register_profile_model.dart.dart';
import 'package:bandhana/features/master_apis/models/your_detail_model.dart';
import 'package:equatable/equatable.dart';
import 'package:bandhana/features/master_apis/models/zodiac_model.dart';
import 'package:bandhana/features/master_apis/models/religion_model.dart';
import 'package:bandhana/features/master_apis/models/caste_model.dart';
import 'package:bandhana/features/master_apis/models/marital_model.dart';
import 'package:bandhana/features/master_apis/models/mother_tongue_model.dart';
import 'package:bandhana/features/master_apis/models/blood_group_model.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
import 'package:bandhana/features/master_apis/models/hobby_model.dart';

abstract class MasterState extends Equatable {}

// Initial
class InitialState extends MasterState {
  @override
  List<Object?> get props => [];
}

// 🌍 Nationality
class GetNationalityLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetNationalityLoadedState extends MasterState {
  final List<NationalityModel> nationalities;
  GetNationalityLoadedState(this.nationalities);

  @override
  List<Object?> get props => [nationalities];
}

class GetNationalityErrorState extends MasterState {
  final String message;
  GetNationalityErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🏞 State
class GetStateLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetStateLoadedState extends MasterState {
  final List<StateModel> states;
  GetStateLoadedState(this.states);

  @override
  List<Object?> get props => [states];
}

class GetStateErrorState extends MasterState {
  final String message;
  GetStateErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🏘 District
class GetDistrictLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetDistrictLoadedState extends MasterState {
  final List<DistrictModel> districts;
  GetDistrictLoadedState(this.districts);

  @override
  List<Object?> get props => [districts];
}

class GetDistrictErrorState extends MasterState {
  final String message;
  GetDistrictErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ⚧ Gender
class GetGenderLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetGenderLoadedState extends MasterState {
  final List<GenderModel> genders;
  GetGenderLoadedState(this.genders);

  @override
  List<Object?> get props => [genders];
}

class GetGenderErrorState extends MasterState {
  final String message;
  GetGenderErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// ✨ Zodiac
class GetZodiacLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetZodiacLoadedState extends MasterState {
  final List<ZodiacModel> zodiacs;
  GetZodiacLoadedState(this.zodiacs);

  @override
  List<Object?> get props => [zodiacs];
}

class GetZodiacErrorState extends MasterState {
  final String message;
  GetZodiacErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🛐 Religion
class GetReligionLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetReligionLoadedState extends MasterState {
  final List<ReligionModel> religions;
  GetReligionLoadedState(this.religions);

  @override
  List<Object?> get props => [religions];
}

class GetReligionErrorState extends MasterState {
  final String message;
  GetReligionErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🏛 Caste
class GetCasteLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetCasteLoadedState extends MasterState {
  final List<CasteModel> castes;
  GetCasteLoadedState(this.castes);

  @override
  List<Object?> get props => [castes];
}

class GetCasteErrorState extends MasterState {
  final String message;
  GetCasteErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 💍 Marital Status
class GetMaritalStatusLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetMaritalStatusLoadedState extends MasterState {
  final List<MaritalModel> statuses;
  GetMaritalStatusLoadedState(this.statuses);

  @override
  List<Object?> get props => [statuses];
}

class GetMaritalStatusErrorState extends MasterState {
  final String message;
  GetMaritalStatusErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🗣 Mother Tongue
class GetMotherTongueLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetMotherTongueLoadedState extends MasterState {
  final List<MotherTongueModel> tongues;
  GetMotherTongueLoadedState(this.tongues);

  @override
  List<Object?> get props => [tongues];
}

class GetMotherTongueErrorState extends MasterState {
  final String message;
  GetMotherTongueErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🩸 Blood Group
class GetBloodGroupLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetBloodGroupLoadedState extends MasterState {
  final List<BloodGroupModel> groups;
  GetBloodGroupLoadedState(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GetBloodGroupErrorState extends MasterState {
  final String message;
  GetBloodGroupErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎓 Education
class GetEducationLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetEducationLoadedState extends MasterState {
  final List<EducationModel> educations;
  GetEducationLoadedState(this.educations);

  @override
  List<Object?> get props => [educations];
}

class GetEducationErrorState extends MasterState {
  final String message;
  GetEducationErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 💼 Profession
class GetProfessionLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetProfessionLoadedState extends MasterState {
  final List<ProfessionModel> professions;
  GetProfessionLoadedState(this.professions);

  @override
  List<Object?> get props => [professions];
}

class GetProfessionErrorState extends MasterState {
  final String message;
  GetProfessionErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 Hobbies
class GetHobbiesLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetHobbiesLoadedState extends MasterState {
  final List<HobbyModel> hobbies;
  GetHobbiesLoadedState(this.hobbies);

  @override
  List<Object?> get props => [hobbies];
}

class GetHobbiesErrorState extends MasterState {
  final String message;
  GetHobbiesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 salary
class GetSalaryLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetSalaryLoadedState extends MasterState {
  final List<SalaryModel> salarys;
  GetSalaryLoadedState(this.salarys);

  @override
  List<Object?> get props => [salarys];
}

class GetSalaryErrorState extends MasterState {
  final String message;
  GetSalaryErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 FamilyType
class GetFamilyTypeLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetFamilyTypeLoadedState extends MasterState {
  final List<FamilyTypeModel> familyTypes;
  GetFamilyTypeLoadedState(this.familyTypes);

  @override
  List<Object?> get props => [familyTypes];
}

class GetFamilyTypeErrorState extends MasterState {
  final String message;
  GetFamilyTypeErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 FamilyStatus
class GetFamilyStatusLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetFamilyStatusLoadedState extends MasterState {
  final List<FamilyStatusModel> familyStatus;
  GetFamilyStatusLoadedState(this.familyStatus);

  @override
  List<Object?> get props => [familyStatus];
}

class GetFamilyStatusErrorState extends MasterState {
  final String message;
  GetFamilyStatusErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 FamilyValues
class GetFamilyValuesLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetFamilyValuesLoadedState extends MasterState {
  final List<FamilyValuesModel> familyValues;
  GetFamilyValuesLoadedState(this.familyValues);

  @override
  List<Object?> get props => [familyValues];
}

class GetFamilyValuesErrorState extends MasterState {
  final String message;
  GetFamilyValuesErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 ProfileDetails
class GetProfileDetailsLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetProfileDetailsLoadedState extends MasterState {
  final RegisterProfileModel profileDetail;
  GetProfileDetailsLoadedState(this.profileDetail);

  @override
  List<Object?> get props => [profileDetail];
}

class GetProfileDetailsErrorState extends MasterState {
  final String message;
  GetProfileDetailsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 ProfileSetup
class GetProfileSetupLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetProfileSetupLoadedState extends MasterState {
  final ProfileSetupModel profileSetup;
  GetProfileSetupLoadedState(this.profileSetup);

  @override
  List<Object?> get props => [profileSetup];
}

class GetProfileSetupErrorState extends MasterState {
  final String message;
  GetProfileSetupErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 FamilyDetails
class GetFamilyDetailsLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetFamilyDetailsLoadedState extends MasterState {
  final FamilyDetailsModel familyDetails;
  GetFamilyDetailsLoadedState(this.familyDetails);

  @override
  List<Object?> get props => [familyDetails];
}

class GetFamilyDetailsErrorState extends MasterState {
  final String message;
  GetFamilyDetailsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 BasicCompatiblity1
class GetBasicCompatiblity1LoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetBasicCompatiblity1LoadedState extends MasterState {
  final BasicCompatiblityModel basicCompatiblity;
  GetBasicCompatiblity1LoadedState(this.basicCompatiblity);

  @override
  List<Object?> get props => [basicCompatiblity];
}

class GetBasicCompatiblity1ErrorState extends MasterState {
  final String message;
  GetBasicCompatiblity1ErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨 BasicCompatiblity2
class GetLifestylePreferenceLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetLifestylePreferenceLoadedState extends MasterState {
  final LifestylePreferenceModel lifestylePreference;
  GetLifestylePreferenceLoadedState(this.lifestylePreference);

  @override
  List<Object?> get props => [lifestylePreference];
}

class GetLifestylePreferenceErrorState extends MasterState {
  final String message;
  GetLifestylePreferenceErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

// 🎨
class GetYourDetailsLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetYourDetailsLoadedState extends MasterState {
  final YourDetailModel yourDetail;
  GetYourDetailsLoadedState(this.yourDetail);

  @override
  List<Object?> get props => [yourDetail];
}

class GetYourDetailsErrorState extends MasterState {
  final String message;
  GetYourDetailsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class GetProfileStatusLoadingState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetProfileStatusLoadedState extends MasterState {
  @override
  List<Object?> get props => [];
}

class GetProfileStatusErrorState extends MasterState {
  final String message;
  GetProfileStatusErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
