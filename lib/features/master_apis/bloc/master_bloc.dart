import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/user_model.dart';
import 'package:bandhana/features/master_apis/models/basic_compatiblity_model.dart';
import 'package:bandhana/features/master_apis/models/district_model.dart';
import 'package:bandhana/features/master_apis/models/family_details_model.dart';
import 'package:bandhana/features/master_apis/models/family_status_model.dart';
import 'package:bandhana/features/master_apis/models/family_type_model.dart';
import 'package:bandhana/features/master_apis/models/family_values_model.dart';
import 'package:bandhana/features/master_apis/models/gender_model.dart';
import 'package:bandhana/features/master_apis/models/hobby_model.dart';
import 'package:bandhana/features/master_apis/models/lifestle_preference_model.dart';
import 'package:bandhana/features/master_apis/models/marital_model.dart';
import 'package:bandhana/features/master_apis/models/nationality_model.dart';
import 'package:bandhana/features/master_apis/models/profile_setup_model.dart';
import 'package:bandhana/features/master_apis/models/salary_model.dart';
import 'package:bandhana/features/master_apis/models/state_model.dart';
import 'package:bandhana/features/master_apis/models/register_profile_model.dart.dart';
import 'package:bandhana/features/master_apis/models/your_detail_model.dart';
import 'package:bandhana/features/master_apis/models/zodiac_model.dart';
import 'package:bandhana/features/master_apis/models/religion_model.dart';
import 'package:bandhana/features/master_apis/models/caste_model.dart';

import 'package:bandhana/features/master_apis/models/mother_tongue_model.dart';
import 'package:bandhana/features/master_apis/models/blood_group_model.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';

import 'package:bandhana/features/master_apis/repository/master_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'master_event.dart';
import 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  final MasterRepo repo = MasterRepo();

  MasterBloc() : super(InitialState()) {
    // 🌍 Nationality
    on<GetNationalityEvent>((event, emit) async {
      emit(GetNationalityLoadingState());
      try {
        final result = await repo.getNationality();
        final list = (result['list'] as List? ?? [])
            .map((e) => NationalityModel.fromJson(e))
            .toList();
        emit(GetNationalityLoadedState(list));
      } catch (e) {
        emit(GetNationalityErrorState(e.toString()));
      }
    });

    // 🏛 State
    on<GetStateEvent>((event, emit) async {
      emit(GetStateLoadingState());
      try {
        final result = await repo.getStates(event.nationalityId);
        final list = (result['list'] as List? ?? [])
            .map((e) => StateModel.fromJson(e))
            .toList();
        emit(GetStateLoadedState(list));
      } catch (e) {
        emit(GetStateErrorState(e.toString()));
      }
    });

    // 🏙 District
    on<GetDistrictEvent>((event, emit) async {
      emit(GetDistrictLoadingState());
      try {
        final result = await repo.getDistricts(event.stateId);
        final list = (result['list'] as List? ?? [])
            .map((e) => DistrictModel.fromJson(e))
            .toList();
        emit(GetDistrictLoadedState(list));
      } catch (e) {
        emit(GetDistrictErrorState(e.toString()));
      }
    });

    // 👤 Gender
    on<GetGenderEvent>((event, emit) async {
      emit(GetGenderLoadingState());
      try {
        final result = await repo.getGender();
        final list = (result['list'] as List? ?? [])
            .map((e) => GenderModel.fromJson(e))
            .toList();
        emit(GetGenderLoadedState(list));
      } catch (e) {
        emit(GetGenderErrorState(e.toString()));
      }
    });

    // ✨ Zodiac
    on<GetZodiacEvent>((event, emit) async {
      emit(GetZodiacLoadingState());
      try {
        final result = await repo.getZodiac();
        final list = (result['list'] as List? ?? [])
            .map((e) => ZodiacModel.fromJson(e))
            .toList();
        emit(GetZodiacLoadedState(list));
      } catch (e) {
        emit(GetZodiacErrorState(e.toString()));
      }
    });

    // 🙏 Religion
    on<GetReligionEvent>((event, emit) async {
      emit(GetReligionLoadingState());
      try {
        final result = await repo.getReligion();
        final list = (result['list'] as List? ?? [])
            .map((e) => ReligionModel.fromJson(e))
            .toList();
        emit(GetReligionLoadedState(list));
      } catch (e) {
        emit(GetReligionErrorState(e.toString()));
      }
    });

    // 🛐 Caste
    on<GetCasteEvent>((event, emit) async {
      emit(GetCasteLoadingState());
      try {
        final result = await repo.getCaste(event.religionId);
        final list = (result['list'] as List? ?? [])
            .map((e) => CasteModel.fromJson(e))
            .toList();
        emit(GetCasteLoadedState(list));
      } catch (e) {
        emit(GetCasteErrorState(e.toString()));
      }
    });

    // 💍 Marital Status
    on<GetMaritalStatusEvent>((event, emit) async {
      emit(GetMaritalStatusLoadingState());
      try {
        final result = await repo.getMaritalStatus();
        final list = (result['list'] as List? ?? [])
            .map((e) => MaritalModel.fromJson(e))
            .toList();
        emit(GetMaritalStatusLoadedState(list));
      } catch (e) {
        emit(GetMaritalStatusErrorState(e.toString()));
      }
    });

    // 🗣 Mother Tongue
    on<GetMotherTongueEvent>((event, emit) async {
      emit(GetMotherTongueLoadingState());
      try {
        final result = await repo.getMotherTongue();
        final list = (result['list'] as List? ?? [])
            .map((e) => MotherTongueModel.fromJson(e))
            .toList();
        emit(GetMotherTongueLoadedState(list));
      } catch (e) {
        emit(GetMotherTongueErrorState(e.toString()));
      }
    });

    // 🩸 Blood Group
    on<GetBloodGroupEvent>((event, emit) async {
      emit(GetBloodGroupLoadingState());
      try {
        final result = await repo.getBloodGroup();
        final list = (result['list'] as List? ?? [])
            .map((e) => BloodGroupModel.fromJson(e))
            .toList();
        emit(GetBloodGroupLoadedState(list));
      } catch (e) {
        emit(GetBloodGroupErrorState(e.toString()));
      }
    });

    // 🎓 Education
    on<GetEducationEvent>((event, emit) async {
      emit(GetEducationLoadingState());
      try {
        final result = await repo.getEducation();
        final list = (result['list'] as List? ?? [])
            .map((e) => EducationModel.fromJson(e))
            .toList();
        emit(GetEducationLoadedState(list));
      } catch (e) {
        emit(GetEducationErrorState(e.toString()));
      }
    });

    // 💼 Profession
    on<GetProfessionEvent>((event, emit) async {
      emit(GetProfessionLoadingState());
      try {
        final result = await repo.getProfession();
        final list = (result['list'] as List? ?? [])
            .map((e) => ProfessionModel.fromJson(e))
            .toList();
        emit(GetProfessionLoadedState(list));
      } catch (e) {
        emit(GetProfessionErrorState(e.toString()));
      }
    });

    // 🎯 Hobbies
    on<GetHobbiesEvent>((event, emit) async {
      emit(GetHobbiesLoadingState());
      try {
        final result = await repo.getHobbies();
        final list = (result['list'] as List? ?? [])
            .map((e) => HobbyModel.fromJson(e))
            .toList();
        emit(GetHobbiesLoadedState(list));
      } catch (e) {
        emit(GetHobbiesErrorState(e.toString()));
      }
    });
    on<GetSalaryEvent>((event, emit) async {
      emit(GetSalaryLoadingState());
      try {
        final result = await repo.getSalary();
        final list = (result['list'] as List? ?? [])
            .map((e) => SalaryModel.fromJson(e))
            .toList();
        emit(GetSalaryLoadedState(list));
      } catch (e) {
        emit(GetSalaryErrorState(e.toString()));
      }
    });
    on<GetFamilyTypeEvent>((event, emit) async {
      emit(GetFamilyTypeLoadingState());
      try {
        final result = await repo.getFamilyType();
        final list = (result['list'] as List? ?? [])
            .map((e) => FamilyTypeModel.fromJson(e))
            .toList();
        emit(GetFamilyTypeLoadedState(list));
      } catch (e) {
        emit(GetFamilyTypeErrorState(e.toString()));
      }
    });
    on<GetFamilyStatusEvent>((event, emit) async {
      emit(GetFamilyStatusLoadingState());
      try {
        final result = await repo.getFamilyStatus();
        final list = (result['list'] as List? ?? [])
            .map((e) => FamilyStatusModel.fromJson(e))
            .toList();
        emit(GetFamilyStatusLoadedState(list));
      } catch (e) {
        emit(GetFamilyStatusErrorState(e.toString()));
      }
    });
    on<GetFamilyValuesEvent>((event, emit) async {
      emit(GetFamilyValuesLoadingState());
      try {
        final result = await repo.getFamilyValues();
        final list = (result['list'] as List? ?? [])
            .map((e) => FamilyValuesModel.fromJson(e))
            .toList();
        emit(GetFamilyValuesLoadedState(list));
      } catch (e) {
        emit(GetFamilyValuesErrorState(e.toString()));
      }
    });
    on<GetProfileDetailsEvent>((event, emit) async {
      emit(GetProfileDetailsLoadingState());
      try {
        final result = await repo.getProfileDetail();
        if (result["status"] == "Success") {
          RegisterProfileModel model = RegisterProfileModel.fromJson(
            result["response"],
          );
          emit(GetProfileDetailsLoadedState(model));
        } else {
          emit(GetProfileDetailsErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetProfileDetailsErrorState(e.toString()));
      }
    });

    on<GetProfileSetupEvent>((event, emit) async {
      emit(GetProfileSetupLoadingState());
      try {
        final result = await repo.getProfileSetup();
        if (result["status"] == "Success") {
          ProfileSetupModel model = ProfileSetupModel.fromJson(
            result["response"],
          );
          emit(GetProfileSetupLoadedState(model));
        } else {
          emit(GetProfileSetupErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetProfileSetupErrorState(e.toString()));
      }
    });
    on<GetFamilyDetails>((event, emit) async {
      emit(GetFamilyDetailsLoadingState());

      try {
        final result = await repo.getFamilyDetails();
        if (result["status"] == "Success") {
          FamilyDetailsModel model = FamilyDetailsModel.fromJson(
            result["response"],
          );
          emit(GetFamilyDetailsLoadedState(model));
        } else {
          emit(GetFamilyDetailsErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetFamilyDetailsErrorState(e.toString()));
      }
    });
    on<GetBasicCompablity1>((event, emit) async {
      emit(GetBasicCompatiblity1LoadingState());

      try {
        final result = await repo.getBasicCompablity1();
        if (result["status"] == "Success") {
          BasicCompatiblityModel model = BasicCompatiblityModel.fromJson(
            result["response"],
          );
          emit(GetBasicCompatiblity1LoadedState(model));
        } else {
          emit(GetBasicCompatiblity1ErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetBasicCompatiblity1ErrorState(e.toString()));
      }
    });

    on<GetLifestylePreferences>((event, emit) async {
      emit(GetLifestylePreferenceLoadingState());

      try {
        final result = await repo.getLifestylePreferences();
        if (result["status"] == "Success") {
          LifestylePreferenceModel model = LifestylePreferenceModel.fromJson(
            result["response"],
          );
          emit(GetLifestylePreferenceLoadedState(model));
        } else {
          emit(GetLifestylePreferenceErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetLifestylePreferenceErrorState(e.toString()));
      }
    });
    on<GetYourDetails>((event, emit) async {
      emit(GetYourDetailsLoadingState());

      try {
        final result = await repo.getYourDetail();
        if (result["status"] == "Success") {
          YourDetailModel model = YourDetailModel.fromJson(result["response"]);
          emit(GetYourDetailsLoadedState(model));
        } else {
          emit(GetYourDetailsErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetYourDetailsErrorState(e.toString()));
      }
    });
    on<GetprofileStatus>((event, emit) async {
      emit(GetProfileStatusLoadingState());

      try {
        final result = await repo.getProfileStatus();
        if (result["status"] == "Success") {
          UserModel model = UserModel.fromJson(result["response"]);

          emit(GetProfileStatusLoadedState());
        } else {
          emit(GetProfileSetupErrorState(result["response"].toString()));
        }
      } catch (e) {
        emit(GetProfileSetupErrorState(e.toString()));
      }
    });

    // 🔥 Load initial events safely
  }
}
