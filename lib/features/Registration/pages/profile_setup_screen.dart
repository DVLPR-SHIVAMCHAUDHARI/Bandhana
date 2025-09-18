import 'dart:developer';
import 'dart:io';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/snack_bar.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
import 'package:bandhana/features/master_apis/models/salary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final ProfileSetupBloc bloc;

  final TextEditingController bioController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController permanentLocationController =
      TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final TextEditingController nativeLocationController =
      TextEditingController();

  SalaryModel? selectedSalaryRange;
  ProfessionModel? selectedProfession;
  EducationModel? selectedEducation;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    bloc = ProfileSetupBloc();

    context.read<MasterBloc>().add(GetEducationEvent());
    context.read<MasterBloc>().add(GetProfessionEvent());
    context.read<MasterBloc>().add(GetSalaryEvent());
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
            "Profile Setup",
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
                  // Images Section
                  Text(
                    "Upload Photos",
                    style: TextStyle(fontSize: 16.sp, fontFamily: Typo.bold),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                    buildWhen: (prev, curr) => curr is PickImageLoadedState,
                    builder: (context, state) {
                      final bloc = context.read<ProfileSetupBloc>();
                      final images = state is PickImageLoadedState
                          ? state.images
                          : [];
                      final remaining =
                          5 - images.length; // dynamic remaining slots
                      log("Remaining slots: $remaining");
                      return Row(
                        children: [
                          if (remaining > 0)
                            GestureDetector(
                              onTap: () {
                                // Every tap recalculates remaining slots
                                bloc.add(
                                  PickImageEvent(
                                    limit: images.isEmpty
                                        ? 5
                                        : 5 - images.length ?? 5,
                                  ),
                                );
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                  color: AppColors.primary.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.primary,
                                  size: 30,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 90,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(images[index].path),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Remove image and update remaining dynamically
                                            bloc.add(RemoveImageEvent(index));
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  20.verticalSpace,

                  // Form Fields Section
                  BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          AppTextField(
                            isRequired: true,
                            title: "About You (Bio)",
                            hint: "Write a short bio about yourself",
                            controller: bioController,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(field: "bio", value: val),
                            ),
                          ),
                          16.verticalSpace,
                          AppTextField(
                            isRequired: true,

                            title: "Age",
                            hint: "Enter your age",
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(field: "age", value: val),
                            ),
                          ),
                          16.verticalSpace,
                          AppTextField(
                            isRequired: true,

                            title: "Height",
                            hint: "Enter your height",
                            controller: heightController,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(field: "height", value: val),
                            ),
                          ),
                          16.verticalSpace,
                          // Profession Dropdown
                          BlocBuilder<MasterBloc, MasterState>(
                            buildWhen: (prev, curr) =>
                                curr is GetProfessionLoadingState ||
                                curr is GetProfessionLoadedState ||
                                curr is GetProfessionErrorState,
                            builder: (context, state) {
                              if (state is GetProfessionLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is GetProfessionLoadedState) {
                                return AppDropdown<String>(
                                  title: "Profession",
                                  isRequired: true,
                                  hint: "Select profession",
                                  items: state.professions
                                      .map((e) => e.profession!)
                                      .toList(),
                                  value: selectedProfession?.profession,
                                  onChanged: (v) {
                                    final selected = state.professions
                                        .firstWhere((e) => e.profession == v);
                                    setState(
                                      () => selectedProfession = selected,
                                    );
                                  },
                                );
                              } else if (state is GetProfessionErrorState) {
                                return Text("Error: ${state.message}");
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          16.verticalSpace,

                          // Education Dropdown
                          BlocBuilder<MasterBloc, MasterState>(
                            buildWhen: (prev, curr) =>
                                curr is GetEducationLoadingState ||
                                curr is GetEducationLoadedState ||
                                curr is GetEducationErrorState,
                            builder: (context, state) {
                              if (state is GetEducationLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is GetEducationLoadedState) {
                                return AppDropdown<String>(
                                  title: "Highest Education",
                                  isRequired: true,
                                  hint: "Select Education",
                                  items: state.educations
                                      .map((e) => e.education!)
                                      .toList(),
                                  value: selectedEducation
                                      ?.education, // <-- use selectedEducation
                                  onChanged: (v) {
                                    final selected = state.educations
                                        .firstWhere((e) => e.education == v);
                                    setState(
                                      () => selectedEducation = selected,
                                    );
                                  },
                                );
                              } else if (state is GetEducationErrorState) {
                                return Text("Error: ${state.message}");
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          16.verticalSpace,
                          // salary Dropdown
                          BlocBuilder<MasterBloc, MasterState>(
                            buildWhen: (prev, curr) =>
                                curr is GetSalaryLoadingState ||
                                curr is GetSalaryLoadedState ||
                                curr is GetSalaryErrorState,
                            builder: (context, state) {
                              if (state is GetSalaryLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is GetSalaryLoadedState) {
                                return AppDropdown<String>(
                                  title: "Salary Range",
                                  isRequired: true,
                                  hint: "Select Salary",
                                  items: state.salarys
                                      .map((e) => e.salaryRange!)
                                      .toList(),
                                  value: selectedSalaryRange
                                      ?.salaryRange, // <-- use selectedEducation
                                  onChanged: (v) {
                                    final selected = state.salarys.firstWhere(
                                      (e) => e.salaryRange == v,
                                    );
                                    setState(
                                      () => selectedSalaryRange = selected,
                                    );
                                  },
                                );
                              } else if (state is GetSalaryErrorState) {
                                return Text("Error: ${state.message}");
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          16.verticalSpace,
                          AppTextField(
                            isRequired: true,

                            lines: 4,
                            title: "Permanent Location",
                            hint: "Enter your permanent address",
                            controller: permanentLocationController,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(
                                field: "permanentLocation",
                                value: val,
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          AppTextField(
                            isRequired: true,

                            lines: 4,
                            title: "Work Location",
                            hint: "Enter your work address",
                            controller: workLocationController,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(
                                field: "workLocation",
                                value: val,
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          AppTextField(
                            lines: 4,
                            isRequired: true,

                            title: "Native Location",
                            hint: "Enter your native address",
                            controller: nativeLocationController,
                            onChanged: (val) => bloc.add(
                              UpdateFieldEvent(
                                field: "nativeLocation",
                                value: val,
                              ),
                            ),
                          ),
                          16.verticalSpace,
                        ],
                      );
                    },
                  ),

                  // Buttons
                  BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
                    listener: (context, state) {
                      if (state is ProfileSetupSubmitSuccessState) {
                        snackbar(
                          color: Colors.green,
                          title: "Great",

                          context,
                          message: state.message,
                        );
                        router.goNamed(Routes.familyDetails.name);
                      } else if (state is ProfileSetupSubmitFailureState) {
                        snackbar(context, message: state.error);
                      }
                    },
                    builder: (context, state) {
                      if (state is ProfileSetupSubmitLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SaveandNextButtons(
                        onSave: () {
                          if (formKey.currentState!.validate() &&
                              selectedEducation != null &&
                              selectedProfession != null &&
                              selectedSalaryRange != null) {
                            final bloc = context.read<ProfileSetupBloc>();

                            bloc.add(
                              SubmitProfileEvent(
                                bio: bioController.text.toString(),
                                age: ageController.text.toString(),
                                height: heightController.text.toString(),
                                permanentLocation: permanentLocationController
                                    .text
                                    .toString(),
                                workLocation: workLocationController.text
                                    .toString(),
                                // nativeLocation: nativeLocationController.text.toString(),
                                education: selectedEducation!.id.toString(),
                                profession: selectedProfession!.id.toString(),
                                salary: selectedSalaryRange!.id.toString(),

                                // 🔑 include images (just pass file paths for now)
                              ),
                            );
                          } else {
                            snackbar(
                              context,
                              message: "Please fill all required fields.",
                            );
                          }
                        },

                        onNext: () {
                          if (formKey.currentState!.validate() &&
                              selectedEducation != null &&
                              selectedProfession != null &&
                              selectedSalaryRange != null) {
                            final bloc = context.read<ProfileSetupBloc>();

                            bloc.add(
                              SubmitProfileEvent(
                                bio: bioController.text.toString(),
                                age: ageController.text.toString(),
                                height: heightController.text.toString(),
                                permanentLocation: permanentLocationController
                                    .text
                                    .toString(),
                                workLocation: workLocationController.text
                                    .toString(),
                                // nativeLocation: nativeLocationController.text.toString(),
                                education: selectedEducation!.id.toString(),
                                profession: selectedProfession!.id.toString(),
                                salary: selectedSalaryRange!.id.toString(),

                                // 🔑 include images (just pass file paths for now)
                              ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
