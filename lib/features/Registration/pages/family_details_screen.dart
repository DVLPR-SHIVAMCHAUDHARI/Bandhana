import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/snack_bar.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:bandhana/features/Registration/Bloc/family_details_bloc/family_detail_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/family_details_bloc/family_detail_event.dart';
import 'package:bandhana/features/Registration/Bloc/family_details_bloc/family_detail_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/family_type_model.dart';
import 'package:bandhana/features/master_apis/models/family_status_model.dart';
import 'package:bandhana/features/master_apis/models/family_values_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyDetailsScreen extends StatefulWidget {
  const FamilyDetailsScreen({super.key});

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  late final FamilyDetailBloc bloc;

  // Controllers
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController fatherOccupationController =
      TextEditingController();
  final TextEditingController fatherContactController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController motherOccupationController =
      TextEditingController();
  final TextEditingController motherContactController = TextEditingController();
  final TextEditingController mamaNameController = TextEditingController();
  final TextEditingController mamaVillageController = TextEditingController();
  final TextEditingController mamaKulController = TextEditingController();
  final TextEditingController relativesController = TextEditingController();

  // Dropdown selections
  String? selectedBrothers;
  String? selectedSisters;
  FamilyTypeModel? selectedFamilyType;
  FamilyStatusModel? selectedFamilyStatus;
  FamilyValuesModel? selectedFamilyValues;
  String selectedFathersCode = "+91"; // default country code
  String selectedMotherssCode = "+91"; // default country code

  final List<String> siblingCount = ["0", "1", "2", "3", "4", "5+"];

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc = FamilyDetailBloc();

    // Call Master APIs
    context.read<MasterBloc>().add(GetFamilyTypeEvent());
    context.read<MasterBloc>().add(GetFamilyStatusEvent());
    context.read<MasterBloc>().add(GetFamilyValuesEvent());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Text(
            "Family Details",
            style: TextStyle(fontSize: 24.sp, fontFamily: Typo.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,

                  // Father Name
                  AppTextField(
                    title: "Father's Name",
                    hint: "Enter father's name",
                    isRequired: true,
                    controller: fatherNameController,
                  ),
                  16.verticalSpace,

                  // Father Occupation
                  AppTextField(
                    isRequired: true,
                    title: "Father's Occupation",
                    hint: "Enter occupation",
                    controller: fatherOccupationController,
                  ),
                  16.verticalSpace,

                  // Father Contact
                  PhoneNumberField(
                    title: "Fathers No.",
                    controller: fatherContactController,
                    initialCountryCode: "+91",
                    onCountryChanged: (code) {
                      selectedFathersCode = code;
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

                  // Mother Name
                  AppTextField(
                    title: "Mother's Name",
                    hint: "Enter mother's name",
                    isRequired: true,
                    controller: motherNameController,
                  ),
                  16.verticalSpace,

                  // Mother Occupation
                  AppTextField(
                    isRequired: true,
                    title: "Mother's Occupation",
                    hint: "Enter occupation",
                    controller: motherOccupationController,
                  ),
                  16.verticalSpace,

                  // Mother Contact
                  PhoneNumberField(
                    title: "Mother's No.",
                    controller: motherContactController,
                    initialCountryCode: "+91",
                    onCountryChanged: (code) {
                      selectedMotherssCode = code;
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

                  // Brothers count
                  AppDropdown<String>(
                    title: "Number of Brothers",
                    hint: "Select brothers count",
                    items: siblingCount,
                    value: selectedBrothers,
                    onChanged: (v) => setState(() => selectedBrothers = v),
                  ),
                  16.verticalSpace,

                  // Sisters count
                  AppDropdown<String>(
                    title: "Number of Sisters",
                    hint: "Select sisters count",
                    items: siblingCount,
                    value: selectedSisters,
                    onChanged: (v) => setState(() => selectedSisters = v),
                  ),
                  16.verticalSpace,

                  // Family Type Dropdown (API)
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyTypeLoadingState ||
                        c is GetFamilyTypeLoadedState ||
                        c is GetFamilyTypeErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyTypeLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyTypeLoadedState) {
                        return AppDropdown<String>(
                          title: "Family Type",
                          hint: "Select family type",
                          items: state.familyTypes
                              .map((e) => e.familyType!)
                              .toList(),
                          value: selectedFamilyType?.familyType,
                          onChanged: (v) {
                            final selected = state.familyTypes.firstWhere(
                              (e) => e.familyType == v,
                            );
                            setState(() => selectedFamilyType = selected);
                          },
                        );
                      } else if (state is GetFamilyTypeErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  16.verticalSpace,

                  // Family Status Dropdown (API)
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyStatusLoadingState ||
                        c is GetFamilyStatusLoadedState ||
                        c is GetFamilyStatusErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyStatusLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyStatusLoadedState) {
                        return AppDropdown<String>(
                          title: "Family Status",
                          hint: "Select family status",
                          items: state.familyStatus
                              .map((e) => e.familyStatus!)
                              .toList(),
                          value: selectedFamilyStatus?.familyStatus,
                          onChanged: (v) {
                            final selected = state.familyStatus.firstWhere(
                              (e) => e.familyStatus == v,
                            );
                            setState(() => selectedFamilyStatus = selected);
                          },
                        );
                      } else if (state is GetFamilyStatusErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  16.verticalSpace,

                  // Family Values Dropdown (API)
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyValuesLoadingState ||
                        c is GetFamilyValuesLoadedState ||
                        c is GetFamilyValuesErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyValuesLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyValuesLoadedState) {
                        return AppDropdown<String>(
                          title: "Family Values",
                          hint: "Select family values",
                          items: state.familyValues
                              .map((e) => e.familyValue!)
                              .toList(),
                          value: selectedFamilyValues?.familyValue,
                          onChanged: (v) {
                            final selected = state.familyValues.firstWhere(
                              (e) => e.familyValue == v,
                            );
                            setState(() => selectedFamilyValues = selected);
                          },
                        );
                      } else if (state is GetFamilyValuesErrorState) {
                        return Text("Error: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  16.verticalSpace,

                  // Mama Name
                  AppTextField(
                    isRequired: true,
                    title: "Maternal Uncle’s (Mama) Name",
                    hint: "Enter mama's name",
                    controller: mamaNameController,
                  ),
                  16.verticalSpace,

                  // Mama Village
                  AppTextField(
                    isRequired: true,
                    title: "Maternal Uncle’s Village",
                    hint: "Enter mama's village",
                    controller: mamaVillageController,
                  ),
                  16.verticalSpace,

                  // Mama Kul
                  AppTextField(
                    isRequired: true,
                    title: "Mama’s Kul",
                    hint: "Enter mama's kul",
                    controller: mamaKulController,
                  ),
                  16.verticalSpace,

                  // Relatives
                  AppTextField(
                    isRequired: true,
                    lines: 4,
                    title: "Relatives / Family References (Surnames)",
                    hint: "Enter relatives or family references",
                    controller: relativesController,
                  ),
                  30.verticalSpace,

                  // Save & Next
                  BlocConsumer<FamilyDetailBloc, FamilyDetailState>(
                    listener: (context, state) {
                      if (state is FamilyDetailSuccess) {
                        snackbar(
                          context,
                          message: state.message,
                          color: Colors.green,
                        );
                        router.goNamed(Routes.compatablity1.name);
                      } else if (state is FamilyDetailFailure) {
                        snackbar(context, message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is FamilyDetailLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SaveandNextButtons(
                        onSave: () {
                          if (formKey.currentState!.validate()) {
                            bloc.add(
                              SubmitFamilyDetailEvent(
                                fathersName: fatherNameController.text,
                                fathersOccupation:
                                    fatherOccupationController.text,
                                fathersContact:
                                    "$selectedFathersCode${fatherContactController.text}"
                                        .trim(),
                                mothersName: motherNameController.text,
                                mothersOccupation:
                                    motherOccupationController.text,
                                mothersContact:
                                    "$selectedMotherssCode${motherContactController.text}"
                                        .trim(),
                                noOfBrothers: selectedBrothers!,

                                noOfSisters: selectedSisters!,
                                familyType:
                                    selectedFamilyType?.id.toString() ?? "",
                                familyStatus:
                                    selectedFamilyStatus?.id.toString() ?? "",
                                familyValues:
                                    selectedFamilyValues?.id.toString() ?? "",
                                maternalUncleMamasName: mamaNameController.text,
                                maternalUncleMamasVillage:
                                    mamaVillageController.text,
                                mamasKulClan: mamaKulController.text,
                                relativesFamilySurnames:
                                    relativesController.text,
                              ),
                            );
                          } else {
                            snackbar(
                              context,
                              message: "Please fill all required fields",
                            );
                          }
                        },
                        onNext: () {
                          if (formKey.currentState!.validate()) {
                            bloc.add(
                              SubmitFamilyDetailEvent(
                                fathersName: fatherNameController.text,
                                fathersOccupation:
                                    fatherOccupationController.text,
                                fathersContact:
                                    "$selectedFathersCode${fatherContactController.text}"
                                        .trim(),
                                mothersName: motherNameController.text,
                                mothersOccupation:
                                    motherOccupationController.text,
                                mothersContact:
                                    "$selectedMotherssCode${motherContactController.text}"
                                        .trim(),
                                noOfBrothers: selectedBrothers!,

                                noOfSisters: selectedSisters!,
                                familyType:
                                    selectedFamilyType?.id.toString() ?? "",
                                familyStatus:
                                    selectedFamilyStatus?.id.toString() ?? "",
                                familyValues:
                                    selectedFamilyValues?.id.toString() ?? "",
                                maternalUncleMamasName: mamaNameController.text,
                                maternalUncleMamasVillage:
                                    mamaVillageController.text,
                                mamasKulClan: mamaKulController.text,
                                relativesFamilySurnames:
                                    relativesController.text,
                              ),
                            );
                          } else {
                            snackbar(
                              context,
                              message: "Please fill all required fields",
                            );
                          }
                          // Same logic as onSave, but you can navigate to next screen after success
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
