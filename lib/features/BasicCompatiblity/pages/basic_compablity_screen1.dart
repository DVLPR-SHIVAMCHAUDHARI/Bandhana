import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/snack_bar.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_bloc.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_event.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_state.dart';
import 'package:bandhana/features/BasicCompatiblity/widgets/app_multiselect_dropdown.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/caste_model.dart';
import 'package:bandhana/features/master_apis/models/district_model.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
import 'package:bandhana/features/master_apis/models/religion_model.dart';
import 'package:bandhana/features/master_apis/models/salary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicCompablityScreen1 extends StatefulWidget {
  const BasicCompablityScreen1({super.key});

  @override
  State<BasicCompablityScreen1> createState() => _BasicCompablityScreen1State();
}

class _BasicCompablityScreen1State extends State<BasicCompablityScreen1> {
  /// ✅ Form Key
  final _formKey = GlobalKey<FormState>();
  List<DistrictModel> selectedNativeLocation = [];
  TextEditingController otherFieldController = TextEditingController();

  RangeValues selectedAgeRange = const RangeValues(21, 30);
  RangeValues selectedHeightRange = const RangeValues(150, 180);

  SalaryModel? selectedSalaryRange;
  ReligionModel? selectedReligion;
  CasteModel? selectedCast;

  List<EducationModel> selectedEducationLevels = [];
  List<ProfessionModel> selectedProfessions = [];
  List<DistrictModel> selectedWorkLocation = [];
  List<DistrictModel> selectedPermanentLocation = [];

  String cmText(double cm) => "${cm.toInt()} cm";

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MasterBloc>();
    bloc.add(GetReligionEvent());
    bloc.add(GetProfessionEvent());
    bloc.add(GetEducationEvent());
    bloc.add(GetDistrictEvent(110));
    bloc.add(GetSalaryEvent());
  }

  @override
  void dispose() {
    otherFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basic Compatibility Questions",
          style: TextStyle(
            color: AppColors.headingblack,
            fontSize: 24.sp,
            fontFamily: Typo.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  25.verticalSpace,
                  Text(
                    "Partner expectations",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18.sp,
                      fontFamily: Typo.bold,
                    ),
                  ),

                  25.verticalSpace,

                  /// 🔹 Age Range
                  Text(
                    "Age Range: ${selectedAgeRange.start.toInt()} - ${selectedAgeRange.end.toInt()}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primaryOpacity,
                    values: selectedAgeRange,
                    min: 18,
                    max: 100,
                    divisions: 82,
                    labels: RangeLabels(
                      selectedAgeRange.start.toInt().toString(),
                      selectedAgeRange.end.toInt().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() => selectedAgeRange = values);
                    },
                  ),

                  30.verticalSpace,

                  /// 🔹 Height Range
                  Text(
                    "Height Range: ${cmText(selectedHeightRange.start)} - ${cmText(selectedHeightRange.end)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primaryOpacity,
                    values: selectedHeightRange,
                    min: 120,
                    max: 250,
                    divisions: 130,
                    labels: RangeLabels(
                      cmText(selectedHeightRange.start),
                      cmText(selectedHeightRange.end),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() => selectedHeightRange = values);
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Religion
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
                          items: state.religions
                              .map((e) => e.religion!)
                              .toList(),
                          value: selectedReligion?.religion,
                          onChanged: (v) {
                            final selected = state.religions.firstWhere(
                              (e) => e.religion == v,
                            );
                            setState(() {
                              selectedReligion = selected;
                              selectedCast = null;
                            });
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

                  25.verticalSpace,

                  /// 🔹 Caste
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
                          value: selectedCast?.caste,
                          onChanged: (v) {
                            final selected = state.castes.firstWhere(
                              (e) => e.caste == v,
                            );
                            setState(() => selectedCast = selected);
                          },
                        );
                      } else if (state is GetCasteErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Education
                  Text(
                    "Education Preferences",
                    style: TextStyle(
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  19.verticalSpace,
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetEducationLoadingState ||
                        curr is GetEducationLoadedState ||
                        curr is GetEducationErrorState,
                    builder: (context, state) {
                      if (state is GetEducationLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetEducationLoadedState) {
                        return MultiSelectDropdown(
                          isRequired: true,
                          items: state.educations
                              .map((e) => e.education ?? "")
                              .toList(),
                          selectedItems: selectedEducationLevels
                              .map((e) => e.education ?? "")
                              .toList(),
                          hintText: "Select Education",
                          onChanged: (values) {
                            setState(() {
                              selectedEducationLevels = values
                                  .map(
                                    (name) => state.educations.firstWhere(
                                      (e) => e.education == name,
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        );
                      } else if (state is GetEducationErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Profession
                  Text(
                    "Profession Preferences",
                    style: TextStyle(
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  19.verticalSpace,
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetProfessionLoadingState ||
                        curr is GetProfessionLoadedState ||
                        curr is GetProfessionErrorState,
                    builder: (context, state) {
                      if (state is GetProfessionLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetProfessionLoadedState) {
                        return MultiSelectDropdown(
                          isRequired: true,
                          items: state.professions
                              .map((e) => e.profession ?? "")
                              .toList(),
                          selectedItems: selectedProfessions
                              .map((e) => e.profession ?? "")
                              .toList(),
                          hintText: "Select Profession",
                          onChanged: (values) {
                            setState(() {
                              selectedProfessions = values
                                  .map(
                                    (name) => state.professions.firstWhere(
                                      (e) => e.profession == name,
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        );
                      } else if (state is GetProfessionErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Salary
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetSalaryLoadingState ||
                        curr is GetSalaryLoadedState ||
                        curr is GetSalaryErrorState,
                    builder: (context, state) {
                      if (state is GetSalaryLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetSalaryLoadedState) {
                        return AppDropdown(
                          isRequired: true,
                          title: "Annual Salary",
                          hint: "Select Salary Range",
                          items: state.salarys
                              .map((e) => e.salaryRange ?? "")
                              .toList(),
                          value: selectedSalaryRange?.salaryRange,
                          onChanged: (val) {
                            setState(() {
                              selectedSalaryRange = val.toString().isEmpty
                                  ? null
                                  : state.salarys.firstWhere(
                                      (e) => e.salaryRange == val,
                                    );
                            });
                          },
                        );
                      } else if (state is GetSalaryErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Work Location
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetDistrictLoadingState ||
                        curr is GetDistrictLoadedState ||
                        curr is GetDistrictErrorState,
                    builder: (context, state) {
                      if (state is GetDistrictLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetDistrictLoadedState) {
                        return MultiSelectDropdown(
                          isRequired: true,
                          items: state.districts
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          selectedItems: selectedWorkLocation
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          hintText: "Select Work Location",
                          onChanged: (selectedNames) {
                            setState(() {
                              selectedWorkLocation = selectedNames
                                  .map(
                                    (name) => state.districts.firstWhere(
                                      (d) => d.districtName == name,
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        );
                      } else if (state is GetDistrictErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Permanent Address
                  Text(
                    "Permanent Address Preferences",
                    style: TextStyle(
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  19.verticalSpace,
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetDistrictLoadingState ||
                        curr is GetDistrictLoadedState ||
                        curr is GetDistrictErrorState,
                    builder: (context, state) {
                      if (state is GetDistrictLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetDistrictLoadedState) {
                        return MultiSelectDropdown(
                          isRequired: true,
                          items: state.districts
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          selectedItems: selectedPermanentLocation
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          hintText: "Select Permanent Address",
                          onChanged: (selectedNames) {
                            setState(() {
                              selectedPermanentLocation = selectedNames
                                  .map(
                                    (name) => state.districts.firstWhere(
                                      (d) => d.districtName == name,
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        );
                      } else if (state is GetDistrictErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Native Location
                  Text(
                    "Native Address Preferences",
                    style: TextStyle(
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  19.verticalSpace,
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (prev, curr) =>
                        curr is GetDistrictLoadingState ||
                        curr is GetDistrictLoadedState ||
                        curr is GetDistrictErrorState,
                    builder: (context, state) {
                      if (state is GetDistrictLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetDistrictLoadedState) {
                        return MultiSelectDropdown(
                          isRequired: true,
                          items: state.districts
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          selectedItems: selectedNativeLocation
                              .map((d) => d.districtName ?? "")
                              .toList(),
                          hintText: "Select Native Address",
                          onChanged: (selectedNames) {
                            setState(() {
                              selectedNativeLocation = selectedNames
                                  .map(
                                    (name) => state.districts.firstWhere(
                                      (d) => d.districtName == name,
                                    ),
                                  )
                                  .toList();
                            });
                          },
                        );
                      } else if (state is GetDistrictErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  25.verticalSpace,

                  /// 🔹 Other Expectation
                  AppTextField(
                    controller: otherFieldController,
                    isRequired: true,
                    title: "Other Expectation",
                    hint: "Write something",
                    lines: 4,
                  ),

                  25.verticalSpace,
                  BlocConsumer<UserPreferencesBloc, UserPreferencesState>(
                    listener: (context, state) {
                      if (state is PreferencesSuccess) {
                        snackbar(
                          context,
                          color: Colors.green,
                          title: "Success",
                          message: state.message,
                        );
                        router.pushNamed(Routes.compatablity2.name);
                      } else if (state is PreferencesFailure) {
                        snackbar(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is PreferencesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SaveandNextButtons(
                        onNext: () {
                          if (_formKey.currentState!.validate()) {
                            final preferences = {
                              "age_range_1": selectedAgeRange.start,
                              "age_range_2": selectedAgeRange.end,
                              "height_range_1": selectedHeightRange.start,
                              "height_range_2": selectedHeightRange.end,
                              "religion": selectedReligion!.id,
                              "caste": selectedCast!.caste,
                              "educaion": selectedEducationLevels
                                  .map((e) => e.id)
                                  .toList(),
                              "profession": selectedProfessions
                                  .map((e) => e.id)
                                  .toList(),
                              "income": selectedSalaryRange!.id,
                              "native_location_1":
                                  selectedNativeLocation[0].districtId,

                              "native_location_2":
                                  selectedNativeLocation[1].districtId,

                              "native_location_3":
                                  selectedNativeLocation[2].districtId,
                              "work_location_1":
                                  selectedWorkLocation[0].districtId,

                              "work_location_2":
                                  selectedWorkLocation[1].districtId,
                              "work_location_3":
                                  selectedWorkLocation[2].districtId,

                              "other_expectations": otherFieldController.text,
                            };

                            context.read<UserPreferencesBloc>().add(
                              SubmitPreferencesEvent(preferences),
                            );
                          } else {
                            snackbar(
                              context,
                              message: "Please fill all required fields.",
                            );
                          }
                        },
                        onSave: () {
                          if (_formKey.currentState!.validate()) {
                            final preferences = {
                              "age_range_1": selectedAgeRange.start,
                              "age_range_2": selectedAgeRange.end,
                              "height_range_1": selectedHeightRange.start,
                              "height_range_2": selectedHeightRange.end,
                              "religion": selectedReligion!.id,
                              "caste": selectedCast!.caste,
                              "educaion": selectedEducationLevels
                                  .map((e) => e.id)
                                  .toList(),
                              "profession": selectedProfessions
                                  .map((e) => e.id)
                                  .toList(),
                              "income": selectedSalaryRange!.id,
                              "native_location_1":
                                  selectedNativeLocation[0].districtId,

                              "native_location_2":
                                  selectedNativeLocation[1].districtId,

                              "native_location_3":
                                  selectedNativeLocation[2].districtId,
                              "work_location_1":
                                  selectedWorkLocation[0].districtId,

                              "work_location_2":
                                  selectedWorkLocation[1].districtId,
                              "work_location_3":
                                  selectedWorkLocation[2].districtId,

                              "other_expectations": otherFieldController.text,
                            };

                            context.read<UserPreferencesBloc>().add(
                              SubmitPreferencesEvent(preferences),
                            );
                          } else {
                            snackbar(
                              context,
                              message: "Please fill all required fields.",
                            );
                          }
                        },
                      );
                    },
                  ),

                  10.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
