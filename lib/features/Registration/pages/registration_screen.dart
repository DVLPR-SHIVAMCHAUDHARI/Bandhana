import 'dart:developer';

import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/snack_bar.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:bandhana/features/Registration/Bloc/registration_bloc/registration_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/registration_bloc/registration_event.dart';
import 'package:bandhana/features/Registration/Bloc/registration_bloc/registration_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/blood_group_model.dart';
import 'package:bandhana/features/master_apis/models/caste_model.dart';
import 'package:bandhana/features/master_apis/models/district_model.dart';
import 'package:bandhana/features/master_apis/models/gender_model.dart';
import 'package:bandhana/features/master_apis/models/marital_model.dart';
import 'package:bandhana/features/master_apis/models/mother_tongue_model.dart';
import 'package:bandhana/features/master_apis/models/nationality_model.dart';
import 'package:bandhana/features/master_apis/models/religion_model.dart';
import 'package:bandhana/features/master_apis/models/state_model.dart';
import 'package:bandhana/features/master_apis/models/register_profile_model.dart.dart';
import 'package:bandhana/features/master_apis/models/zodiac_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key, required this.type});
  String type;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController kulController = TextEditingController();
  TextEditingController birthPlace = TextEditingController();
  TextEditingController specificDisability = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController birthTimeController = TextEditingController();

  // Dropdown selections
  GenderModel? gender;
  NationalityModel? selectedNationality;
  StateModel? selectedState;
  DistrictModel? selectedDistrict;
  ZodiacModel? selectedZodiac;
  ReligionModel? religion;
  CasteModel? caste;
  MotherTongueModel? motherTongue;
  MaritalModel? maritalStatus;
  BloodGroupModel? bloodGroup;
  String? disability;
  String? isDisable;
  String selectedCode = "+91"; // default country code

  // Date & Time
  DateTime? dob;
  TimeOfDay? birthTime;

  // Hobbies
  final List<String> emojis = [
    "📖 ",
    "🎶 ",
    "✈️ ",
    "⚽️ ",
    "🧑🏻‍🍳 ",
    "🎨 ",
    "📸 ",
    "🎮 ",
    "🪴 ",
    "📝 ",
  ];
  final Set<String> selectedHobbies = {};
  final Set<int> selectedHobbyIds = {};

  @override
  @override
  void initState() {
    super.initState();
    final bloc = context.read<MasterBloc>();
    bloc.add(GetNationalityEvent());
    bloc.add(GetGenderEvent());
    bloc.add(GetReligionEvent());
    bloc.add(GetMotherTongueEvent());
    bloc.add(GetMaritalStatusEvent());
    bloc.add(GetBloodGroupEvent());

    bloc.add(GetHobbiesEvent());
    bloc.add(GetProfileDetailsEvent());
    bloc.add(GetZodiacEvent());
  }

  Widget _buildDatePicker(String title, String hint) {
    final today = DateTime.now();
    final earliestDate = DateTime(
      today.year - 100,
      today.month,
      today.day,
    ); // optional: max age 100
    final latestDate = DateTime(
      today.year - 18,
      today.month,
      today.day,
    ); // minimum age 21

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: latestDate,
              firstDate: earliestDate,
              lastDate: latestDate,
            );
            if (picked != null) {
              setState(() {
                dob = picked;
                dobController.text = DateFormat('yyyy-MM-dd').format(picked);
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: dobController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please select your date of birth";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryOpacity,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildTimePicker(String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              setState(() {
                birthTime = picked;
                final hour = picked.hour.toString().padLeft(2, '0');
                final minute = picked.minute.toString().padLeft(2, '0');
                birthTimeController.text = "$hour:$minute";
              });
            }
          },
          child: IgnorePointer(
            // Make TextFormField not editable but still focusable for form
            child: TextFormField(
              controller: birthTimeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryOpacity,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a time';
                }
                return null;
              },
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildHobbies() {
    return BlocBuilder<MasterBloc, MasterState>(
      buildWhen: (prev, curr) =>
          curr is GetHobbiesLoadingState ||
          curr is GetHobbiesLoadedState ||
          curr is GetHobbiesErrorState,
      builder: (context, state) {
        if (state is GetHobbiesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetHobbiesLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Your Hobbies",
                style: TextStyle(
                  fontFamily: Typo.bold,
                  fontSize: 16.sp,
                  color: const Color(0xff383838),
                ),
              ),
              10.verticalSpace,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(state.hobbies.length, (index) {
                  final hobby = state.hobbies[index];
                  final emoji = index < emojis.length
                      ? emojis[index]
                      : "🎯"; // fallback emoji
                  final isSelected = selectedHobbies.contains(
                    hobby.hobby ?? "",
                  );

                  return ChoiceChip(
                    checkmarkColor: AppColors.primary,
                    label: Text(
                      "$emoji ${hobby.hobby ?? ""}",
                      style: TextStyle(
                        fontFamily: Typo.medium,
                        color: isSelected ? AppColors.primary : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedHobbies.add(hobby.hobby ?? ""); // for display
                          selectedHobbyIds.add(hobby.id!); // save ID for API
                        } else {
                          selectedHobbies.remove(hobby.hobby ?? "");
                          selectedHobbyIds.remove(hobby.id!);
                        }
                      });
                    },

                    selectedColor: AppColors.primary.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade400,
                      ),
                    ),
                  );
                }),
              ),

              16.verticalSpace,
            ],
          );
        } else if (state is GetHobbiesErrorState) {
          return Text("Error: ${state.message}");
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: widget.type == "edit"
            ? null
            : BackButton(
                color: Colors.black,
                onPressed: () => router.goNamed(Routes.signin.name),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                BlocListener<MasterBloc, MasterState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    if (state is GetProfileDetailsLoadedState) {
                      fullNameController.text = state.profileDetail.fullname!;
                    }
                  },
                  child: AppTextField(
                    isRequired: true,
                    title: "Full Name",
                    hint: "Full Name",
                    controller: fullNameController,
                  ),
                ),
                16.verticalSpace,

                // Gender
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetGenderLoadingState ||
                      curr is GetGenderLoadedState ||
                      curr is GetGenderErrorState,
                  builder: (context, state) {
                    if (state is GetGenderLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetGenderLoadedState) {
                      return AppDropdown(
                        isRequired: true,
                        title: "Gender",
                        hint: "Select Gender",
                        items: state.genders.map((e) => e.name!).toList(),
                        value: gender?.name,
                        onChanged: (v) {
                          final selected = state.genders.firstWhere(
                            (e) => e.name == v,
                          );
                          setState(() => gender = selected);
                        },
                      );
                    } else if (state is GetGenderErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),
                BlocListener<MasterBloc, MasterState>(
                  listener: (context, state) {
                    if (state is GetProfileDetailsLoadedState) {
                      RegisterProfileModel profile = state.profileDetail;

                      // Text Fields
                      fullNameController.text = profile.fullname ?? "";
                      String formatNumber(String? fullNumber) {
                        if (fullNumber == null || fullNumber.isEmpty) return "";

                        // Check if it starts with '+' and remove the country code
                        if (fullNumber.startsWith("+")) {
                          // Find the first digit after the country code (after the first 1-3 digits)
                          // We'll remove everything until the last 10 digits
                          if (fullNumber.length > 10) {
                            return fullNumber.substring(fullNumber.length - 10);
                          }
                        }
                        return fullNumber;
                      }

                      // Usage
                      contactController.text = formatNumber(
                        profile.contactNumber,
                      );
                      dobController.text = profile.dateOfBirth ?? "";
                      birthTimeController.text =
                          profile.birthTime
                              ?.split(":")
                              .sublist(0, 2)
                              .join(":") ??
                          "";
                      birthPlace.text = profile.birthPlace ?? "";
                      kulController.text = profile.kul ?? "";
                      emailController.text = profile.email ?? "";
                      specificDisability.text = profile.specificDisablity ?? "";
                      disability = profile.disablity;

                      // Dropdowns

                      selectedZodiac = ZodiacModel(
                        id: int.tryParse(profile.zodiac.toString() ?? '0'),
                        zodiac: profile.zodiacName,
                      );

                      gender = GenderModel(
                        id: int.tryParse(profile.gender.toString() ?? '0'),
                        name: profile.genderName,
                      );

                      selectedNationality = NationalityModel(
                        id: int.tryParse(profile.nationality.toString() ?? '0'),
                        nationality: profile.nationalityName,
                      );

                      selectedState = StateModel(
                        stateId: int.tryParse(profile.state.toString() ?? '0'),
                        stateName: profile.stateName,
                      );

                      selectedDistrict = DistrictModel(
                        districtId: int.tryParse(
                          profile.district.toString() ?? '0',
                        ),
                        districtName: profile.districtName,
                      );

                      religion = ReligionModel(
                        id: int.tryParse(profile.religion.toString() ?? '0'),
                        religion: profile.religionName,
                      );

                      caste = CasteModel(
                        id: int.tryParse(profile.caste.toString() ?? '0'),
                        caste: profile.casteName,
                      );

                      motherTongue = MotherTongueModel(
                        id: int.tryParse(
                          profile.motherTongue.toString() ?? '0',
                        ),
                        motherTongue: profile.motherTongueName,
                      );

                      maritalStatus = MaritalModel(
                        id: int.tryParse(
                          profile.maritalStatus.toString() ?? '0',
                        ),
                        maritalStatus: profile.maritalStatusName,
                      );

                      bloodGroup = BloodGroupModel(
                        id: int.tryParse(profile.bloodGroup.toString() ?? '0'),
                        bloodGroup: profile.bloodGroupName,
                      );

                      // Hobbies
                      selectedHobbyIds.clear();
                      selectedHobbies.clear();
                      if (profile.hobbies != null) {
                        for (var hobby in profile.hobbies!) {
                          selectedHobbyIds.add(int.parse(hobby.id!));
                          selectedHobbies.add(hobby.hobbyName!);
                        }
                      }

                      // Force rebuild to update UI
                      setState(() {});
                    }
                  },
                  child: const SizedBox.shrink(),
                ),

                16.verticalSpace,

                // Nationality
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetNationalityLoadingState ||
                      curr is GetNationalityLoadedState ||
                      curr is GetNationalityErrorState,
                  builder: (context, state) {
                    if (state is GetNationalityLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetNationalityLoadedState) {
                      return AppDropdown(
                        isRequired: true,
                        title: "Nationality",
                        hint: "Select Nationality",
                        items: state.nationalities
                            .map((e) => e.nationality!)
                            .toList(),
                        value: selectedNationality?.nationality,
                        onChanged: (v) {
                          final selected = state.nationalities.firstWhere(
                            (e) => e.nationality == v,
                          );
                          setState(() {
                            selectedNationality = selected;
                            selectedState = null;
                            selectedDistrict = null;
                          });
                          context.read<MasterBloc>().add(
                            GetStateEvent(selected.id!),
                          );
                        },
                      );
                    } else if (state is GetNationalityErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),
                16.verticalSpace,

                // State
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetStateLoadingState ||
                      curr is GetStateLoadedState ||
                      curr is GetStateErrorState,
                  builder: (context, state) {
                    if (state is GetStateLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetStateLoadedState) {
                      return AppDropdown(
                        title: "State",
                        isRequired: true,

                        hint: "Select State",
                        items: state.states.map((e) => e.stateName!).toList(),
                        value: selectedState?.stateName,
                        onChanged: (v) {
                          final selected = state.states.firstWhere(
                            (e) => e.stateName == v,
                          );
                          setState(() {
                            selectedState = selected;
                            selectedDistrict = null;
                          });
                          context.read<MasterBloc>().add(
                            GetDistrictEvent(selected.stateId!),
                          );
                        },
                      );
                    } else if (state is GetStateErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),
                16.verticalSpace,

                // District
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetDistrictLoadingState ||
                      curr is GetDistrictLoadedState ||
                      curr is GetDistrictErrorState,
                  builder: (context, state) {
                    if (state is GetDistrictLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetDistrictLoadedState) {
                      return AppDropdown(
                        title: "District",
                        isRequired: true,

                        hint: "Select District",
                        items: state.districts
                            .map((e) => e.districtName!)
                            .toList(),
                        value: selectedDistrict?.districtName,
                        onChanged: (v) {
                          final selected = state.districts.firstWhere(
                            (e) => e.districtName == v,
                          );
                          setState(() => selectedDistrict = selected);
                        },
                      );
                    } else if (state is GetDistrictErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),
                16.verticalSpace,

                AppTextField(
                  isRequired: true,
                  title: "Birth Place",
                  hint: "Place",
                  lines: 2,
                  controller: birthPlace,
                ),
                16.verticalSpace,

                // Date & Time Pickers
                _buildDatePicker("Date of Birth", "01/07/2025"),
                16.verticalSpace,
                _buildTimePicker("Birth time", "01:10 pm"),
                16.verticalSpace,

                // Static Dropdowns
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetZodiacLoadingState ||
                      curr is GetZodiacLoadedState ||
                      curr is GetZodiacErrorState,
                  builder: (context, state) {
                    if (state is GetZodiacLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetZodiacLoadedState) {
                      return AppDropdown(
                        title: "Zodiac",
                        isRequired: true,

                        hint: "Select Zodiac",
                        items: state.zodiacs.map((e) => e.zodiac!).toList(),
                        value: selectedZodiac?.zodiac,
                        onChanged: (v) {
                          final selected = state.zodiacs.firstWhere(
                            (e) => e.zodiac == v,
                          );
                          setState(() => selectedZodiac = selected);
                        },
                      );
                    } else if (state is GetZodiacErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetReligionLoadingState ||
                      curr is GetReligionLoadedState ||
                      curr is GetReligionErrorState,
                  builder: (context, state) {
                    if (state is GetReligionLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetReligionLoadedState) {
                      return AppDropdown(
                        isRequired: true,

                        title: "Religion",
                        hint: "Select Religion",
                        items: state.religions.map((e) => e.religion!).toList(),
                        value: religion?.religion,
                        onChanged: (v) {
                          final selected = state.religions.firstWhere(
                            (e) => e.religion == v,
                          );
                          setState(() {
                            religion = selected;
                            caste = null; // reset caste when religion changes
                          });
                          // 🔥 trigger caste load based on religionId
                          context.read<MasterBloc>().add(
                            GetCasteEvent(selected.id!),
                          );
                        },
                      );
                    } else if (state is GetReligionErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetCasteLoadingState ||
                      curr is GetCasteLoadedState ||
                      curr is GetCasteErrorState,
                  builder: (context, state) {
                    if (state is GetCasteLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetCasteLoadedState) {
                      return AppDropdown(
                        isRequired: true,

                        title: "Caste",
                        hint: "Select Caste",
                        items: state.castes.map((e) => e.caste!).toList(),
                        value: caste?.caste,
                        onChanged: (v) {
                          final selected = state.castes.firstWhere(
                            (e) => e.caste == v,
                          );
                          setState(() => caste = selected);
                        },
                      );
                    } else if (state is GetCasteErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,
                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetMotherTongueLoadingState ||
                      curr is GetMotherTongueLoadedState ||
                      curr is GetMotherTongueErrorState,
                  builder: (context, state) {
                    if (state is GetMotherTongueLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetMotherTongueLoadedState) {
                      return AppDropdown(
                        title: "Mother Tongue",
                        isRequired: true,

                        hint: "Select Mother Tongue",
                        items: state.tongues
                            .map((e) => e.motherTongue.toString())
                            .toList(),
                        value: motherTongue?.motherTongue,
                        onChanged: (v) {
                          final selected = state.tongues.firstWhere(
                            (e) => e.motherTongue == v,
                          );
                          setState(() => motherTongue = selected);
                        },
                      );
                    } else if (state is GetMotherTongueErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,

                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetMaritalStatusLoadingState ||
                      curr is GetMaritalStatusLoadedState ||
                      curr is GetMaritalStatusErrorState,
                  builder: (context, state) {
                    if (state is GetMaritalStatusLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetMaritalStatusLoadedState) {
                      log("helllllo${state.statuses.toString()}");
                      return AppDropdown(
                        isRequired: true,

                        title: "Marital Status",
                        hint: "Select Marital Status",
                        items: state.statuses
                            .map((e) => e.maritalStatus!)
                            .toList(),
                        value: maritalStatus?.maritalStatus,
                        onChanged: (v) {
                          final selected = state.statuses.firstWhere(
                            (e) => e.maritalStatus == v,
                          );
                          setState(() => maritalStatus = selected);
                        },
                      );
                    } else if (state is GetMaritalStatusErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,

                BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (prev, curr) =>
                      curr is GetBloodGroupLoadingState ||
                      curr is GetBloodGroupLoadedState ||
                      curr is GetBloodGroupErrorState,
                  builder: (context, state) {
                    if (state is GetBloodGroupLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetBloodGroupLoadedState) {
                      return AppDropdown(
                        title: "Blood Group",
                        isRequired: true,

                        hint: "Select Blood Group",
                        items: state.groups.map((e) => e.bloodGroup!).toList(),
                        value: bloodGroup?.bloodGroup,
                        onChanged: (v) {
                          final selected = state.groups.firstWhere(
                            (e) => e.bloodGroup == v,
                          );
                          setState(() => bloodGroup = selected);
                        },
                      );
                    } else if (state is GetBloodGroupErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox.shrink();
                  },
                ),

                16.verticalSpace,

                AppDropdown(
                  isRequired: true,

                  title: "Disability",
                  hint: "No",
                  items: ["No", "Yes"],
                  value: disability,
                  onChanged: (v) => setState(() => disability = v),
                ),
                16.verticalSpace,

                if (disability == "Yes")
                  AppTextField(
                    isRequired: disability == "Yes" ? true : false,
                    title: "Specify Disability",
                    hint: "Disability",
                    controller: specificDisability,
                  ),
                16.verticalSpace,

                AppTextField(
                  isRequired: true,
                  title: "Kul(clan)",
                  hint: "Kul/gotra",
                  controller: kulController,
                ),
                16.verticalSpace,
                PhoneNumberField(
                  title: "Phone No.",
                  controller: contactController,
                  initialCountryCode: "+91",
                  onCountryChanged: (code) {
                    selectedCode = code;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your phone number";
                    }
                    if (value.trim().length < 10) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                AppTextField(
                  title: "Email (if any)",
                  hint: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                16.verticalSpace,

                _buildHobbies(),
                16.verticalSpace,

                // Save & Next
                BlocProvider(
                  create: (context) => RegistrationBloc(),
                  child: Builder(
                    builder: (context) {
                      return BlocBuilder<RegistrationBloc, RegistrationState>(
                        builder: (context, state) {
                          return SaveandNextButtons(
                            onNext: () {
                              // Validate the form first
                              if (_formKey.currentState!.validate()) {
                                final number =
                                    "$selectedCode${contactController.text}";
                                if (gender == null ||
                                    selectedNationality == null ||
                                    selectedState == null ||
                                    selectedDistrict == null ||
                                    selectedZodiac == null ||
                                    religion == null ||
                                    caste == null ||
                                    motherTongue == null ||
                                    maritalStatus == null ||
                                    bloodGroup == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select all required fields",
                                      ),
                                    ),
                                  );
                                  return;
                                } else if (selectedHobbyIds.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select at least one hobby",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Send event to bloc
                                context.read<RegistrationBloc>().add(
                                  RegisterUserEvent(
                                    fullName: fullNameController.text.trim(),
                                    genderId: gender!.id!,
                                    nationalityId: selectedNationality!.id!,
                                    stateId: selectedState!.stateId!,
                                    districtId: selectedDistrict!.districtId!,
                                    birthPlace: birthPlace.text.trim(),
                                    dateOfBirth: dobController.text,
                                    birthTime: birthTimeController.text,
                                    zodiacId: selectedZodiac!.id!,
                                    religionId: religion!.id!,
                                    casteId: caste!.id!,
                                    maritalStatusId: maritalStatus!.id!,
                                    hobbiesList: selectedHobbyIds.toList(),
                                    motherTongueId: motherTongue!.id!,
                                    bloodGroupId: bloodGroup!.id!,
                                    disability: disability ?? 'No',
                                    specificDisability: specificDisability.text
                                        .trim(),
                                    kul: kulController.text.trim(),
                                    contactNumber:
                                        "$selectedCode${contactController.text}"
                                            .trim(),
                                    email: emailController.text.trim(),
                                  ),
                                );

                                // Navigate to next screen after submission
                                widget.type == "edit"
                                    ? snackbar(
                                        context,
                                        color: Colors.green,
                                        message: "Success",
                                        title: "Great",
                                      )
                                    : router.goNamed(Routes.profilesetup.name);
                                context.read<MasterBloc>().add(
                                  GetprofileStatus(),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please fill all required fields",
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
