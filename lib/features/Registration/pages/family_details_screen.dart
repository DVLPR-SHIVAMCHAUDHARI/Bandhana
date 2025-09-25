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
  String selectedFathersCode = "+91";
  String selectedMothersCode = "+91";

  final List<String> siblingCount = ["0", "1", "2", "3", "4", "5+"];

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc = FamilyDetailBloc();

    final masterBloc = context.read<MasterBloc>();
    masterBloc.add(GetFamilyTypeEvent());
    masterBloc.add(GetFamilyStatusEvent());
    masterBloc.add(GetFamilyValuesEvent());
    masterBloc.add(GetFamilyDetails());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  T? safeDropdownValue<T>(T? value, List<T> items) {
    if (value != null && items.contains(value)) return value;
    return items.isNotEmpty ? items.first : null;
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
                    title: "Father's Occupation",
                    hint: "Enter occupation",
                    isRequired: true,
                    controller: fatherOccupationController,
                  ),
                  16.verticalSpace,

                  // Father Contact
                  PhoneNumberField(
                    title: "Father's No.",
                    controller: fatherContactController,
                    initialCountryCode: selectedFathersCode,
                    onCountryChanged: (code) => selectedFathersCode = code,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter phone number";
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
                    title: "Mother's Occupation",
                    hint: "Enter occupation",
                    isRequired: true,
                    controller: motherOccupationController,
                  ),
                  16.verticalSpace,

                  // Mother Contact
                  PhoneNumberField(
                    title: "Mother's No.",
                    controller: motherContactController,
                    initialCountryCode: selectedMothersCode,
                    onCountryChanged: (code) => selectedMothersCode = code,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter phone number";
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
                    value: safeDropdownValue(selectedBrothers, siblingCount),
                    onChanged: (v) => setState(() => selectedBrothers = v),
                  ),
                  16.verticalSpace,

                  // Sisters count
                  AppDropdown<String>(
                    title: "Number of Sisters",
                    hint: "Select sisters count",
                    items: siblingCount,
                    value: safeDropdownValue(selectedSisters, siblingCount),
                    onChanged: (v) => setState(() => selectedSisters = v),
                  ),
                  16.verticalSpace,

                  // Family Type Dropdown
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyTypeLoadingState ||
                        c is GetFamilyTypeLoadedState ||
                        c is GetFamilyTypeErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyTypeLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyTypeLoadedState) {
                        final items = state.familyTypes
                            .map((e) => e.familyType!)
                            .toList();

                        // If selectedFamilyType is null, create from ID
                        if (selectedFamilyType == null &&
                            state.familyTypes.isNotEmpty) {
                          selectedFamilyType = FamilyTypeModel(
                            id: state.familyTypes.first.id,
                            familyType: state.familyTypes.first.familyType,
                          );
                        }

                        return AppDropdown<String>(
                          title: "Family Type",
                          hint: "Select family type",
                          items: items,
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

                  // Family Status Dropdown
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyStatusLoadingState ||
                        c is GetFamilyStatusLoadedState ||
                        c is GetFamilyStatusErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyStatusLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyStatusLoadedState) {
                        final items = state.familyStatus
                            .map((e) => e.familyStatus!)
                            .toList();

                        if (selectedFamilyStatus == null &&
                            state.familyStatus.isNotEmpty) {
                          selectedFamilyStatus = FamilyStatusModel(
                            id: state.familyStatus.first.id,
                            familyStatus: state.familyStatus.first.familyStatus,
                          );
                        }

                        return AppDropdown<String>(
                          title: "Family Status",
                          hint: "Select family status",
                          items: items,
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
                  BlocListener<MasterBloc, MasterState>(
                    listener: (context, state) {
                      if (state is GetFamilyDetailsLoadedState) {
                        final details = state.familyDetails;

                        // Text fields
                        fatherNameController.text = details.fathersName ?? "";
                        fatherOccupationController.text =
                            details.fathersOccupation ?? "";
                        motherNameController.text = details.mothersName ?? "";
                        motherOccupationController.text =
                            details.mothersOccupation ?? "";

                        selectedBrothers = details.noOfBrothers.toString();
                        selectedSisters = details.noOfSisters.toString();

                        // Remove country code from phone number for input field
                        String formatNumber(String? fullNumber) {
                          if (fullNumber == null || fullNumber.isEmpty) {
                            return "";
                          }
                          return fullNumber.length > 3
                              ? fullNumber.substring(fullNumber.length - 10)
                              : fullNumber;
                        }

                        fatherContactController.text = formatNumber(
                          details.fathersContact,
                        );
                        motherContactController.text = formatNumber(
                          details.mothersContact,
                        );

                        selectedFathersCode =
                            details.fathersContact?.substring(0, 3) ?? "+91";
                        selectedMothersCode =
                            details.mothersContact?.substring(0, 3) ?? "+91";

                        // Maternal uncle details
                        mamaNameController.text =
                            details.maternalUncleMamasName ?? "";
                        mamaVillageController.text =
                            details.maternalUncleMamasVillage ?? "";
                        mamaKulController.text = details.mamasKulClan ?? "";
                        relativesController.text =
                            details.relativesFamilySurnames ?? "";

                        // Create dropdown objects from API response
                        if (details.familyType != null) {
                          selectedFamilyType = FamilyTypeModel(
                            id: details.familyType,
                            familyType: details.familyTypeName ?? "",
                          );
                        }
                        if (details.familyStatus != null) {
                          selectedFamilyStatus = FamilyStatusModel(
                            id: details.familyStatus,
                            familyStatus: details.familyStatusName ?? "",
                          );
                        }
                        if (details.familyValues != null) {
                          selectedFamilyValues = FamilyValuesModel(
                            id: details.familyValues,
                            familyValue: details.familyValuesName ?? "",
                          );
                        }

                        setState(() {}); // Update UI
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),

                  // Family Values Dropdown
                  BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (p, c) =>
                        c is GetFamilyValuesLoadingState ||
                        c is GetFamilyValuesLoadedState ||
                        c is GetFamilyValuesErrorState,
                    builder: (context, state) {
                      if (state is GetFamilyValuesLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is GetFamilyValuesLoadedState) {
                        final items = state.familyValues
                            .map((e) => e.familyValue!)
                            .toList();

                        if (selectedFamilyValues == null &&
                            state.familyValues.isNotEmpty) {
                          selectedFamilyValues = FamilyValuesModel(
                            id: state.familyValues.first.id,
                            familyValue: state.familyValues.first.familyValue,
                          );
                        }

                        return AppDropdown<String>(
                          title: "Family Values",
                          hint: "Select family values",
                          items: items,
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

                  // Maternal Uncle Details
                  AppTextField(
                    title: "Maternal Uncle’s (Mama) Name",
                    hint: "Enter mama's name",
                    isRequired: true,
                    controller: mamaNameController,
                  ),
                  16.verticalSpace,
                  AppTextField(
                    title: "Maternal Uncle’s Village",
                    hint: "Enter mama's village",
                    isRequired: true,
                    controller: mamaVillageController,
                  ),
                  16.verticalSpace,
                  AppTextField(
                    title: "Mama’s Kul",
                    hint: "Enter mama's kul",
                    isRequired: true,
                    controller: mamaKulController,
                  ),
                  16.verticalSpace,
                  AppTextField(
                    title: "Relatives / Family References (Surnames)",
                    hint: "Enter relatives",
                    isRequired: true,
                    lines: 4,
                    controller: relativesController,
                  ),
                  30.verticalSpace,

                  // Save & Next
                  BlocConsumer<FamilyDetailBloc, FamilyDetailState>(
                    listener: (context, state) {
                      if (state is FamilyDetailSuccess) {
                        snackbar(
                          context,
                          title: "Great",
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
                      return SaveandNextButtons(onNext: submitFamilyDetails);
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

  void submitFamilyDetails() {
    if (formKey.currentState!.validate()) {
      bloc.add(
        SubmitFamilyDetailEvent(
          fathersName: fatherNameController.text,
          fathersOccupation: fatherOccupationController.text,
          fathersContact: "$selectedFathersCode${fatherContactController.text}"
              .trim(),
          mothersName: motherNameController.text,
          mothersOccupation: motherOccupationController.text,
          mothersContact: "$selectedMothersCode${motherContactController.text}"
              .trim(),
          noOfBrothers: selectedBrothers!,
          noOfSisters: selectedSisters!,
          familyType: selectedFamilyType?.id.toString() ?? "",
          familyStatus: selectedFamilyStatus?.id.toString() ?? "",
          familyValues: selectedFamilyValues?.id.toString() ?? "",
          maternalUncleMamasName: mamaNameController.text,
          maternalUncleMamasVillage: mamaVillageController.text,
          mamasKulClan: mamaKulController.text,
          relativesFamilySurnames: relativesController.text,
        ),
      );
    } else {
      snackbar(context, message: "Please fill all required fields");
    }
  }
}
