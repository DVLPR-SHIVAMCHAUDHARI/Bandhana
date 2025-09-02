import 'dart:io';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/BasicCompatiblity/repositories/basic_compatiblity_repository.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController bioController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController heightController = TextEditingController();

  final TextEditingController salaryController = TextEditingController();

  final TextEditingController permanentLocationController =
      TextEditingController();

  final TextEditingController workLocationController = TextEditingController();
  String? selectedSalaryRange;
  String? selectedProfession;
  String? selectedJobRole;
  final List<String> educationList = [
    "High School",
    "Bachelor",
    "Master",
    "PhD",
  ];

  final List<String> professionList = [
    "Engineer",
    "Doctor",
    "Teacher",
    "Business",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSetupBloc(),
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
            child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
              builder: (context, state) {
                final bloc = context.read<ProfileSetupBloc>();
                List<XFile> images = [];
                if (state is PickImageLoadedState) images = state.images;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Photos",
                      style: TextStyle(fontSize: 16.sp, fontFamily: Typo.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => bloc.add(PickImageEvent()),
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
                                        borderRadius: BorderRadius.circular(12),
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
                                        onTap: () =>
                                            bloc.add(RemoveImageEvent(index)),
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
                    ),
                    20.verticalSpace,

                    // ✅ Form Fields
                    AppTextField(
                      title: "About You (Bio)",
                      hint: "Write a short bio about yourself",
                      controller: bioController,
                      onChanged: (val) =>
                          bloc.add(UpdateFieldEvent(field: "bio", value: val)),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      title: "Age",
                      hint: "Enter your age",
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) =>
                          bloc.add(UpdateFieldEvent(field: "age", value: val)),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      title: "Height",
                      hint: "Enter your height",
                      controller: heightController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "height", value: val),
                      ),
                    ),
                    16.verticalSpace,
                    AppDropdown<String>(
                      title: "Education",
                      hint: "Select your highest education level",
                      value: bloc.profileData["education"],
                      items: educationList,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "education", value: val),
                      ),
                    ),
                    16.verticalSpace,
                    AppDropdown(
                      title: 'Profession',
                      hint: 'select',
                      items: professions['professions']!,
                      value: selectedProfession,
                      onChanged: (val) {
                        setState(() {
                          selectedProfession = val.toString();
                          selectedJobRole =
                              null; // 🔹 Reset caste when religion changes
                        });
                      },
                    ),
                    25.verticalSpace,
                    AppDropdown(
                      title: 'Job role',
                      hint: 'select',
                      items: (selectedProfession != null)
                          ? professions[selectedProfession]!
                          : [], // ✅ safe fallback
                      value: selectedJobRole,
                      onChanged: (val) {
                        setState(() {
                          selectedJobRole = val.toString();
                        });
                      },
                    ),

                    25.verticalSpace,
                    16.verticalSpace,
                    AppDropdown(
                      title: 'Annual Salary',
                      hint: 'Select Salary Range',
                      items: annualSalaryRanges,
                      value: selectedSalaryRange,
                      onChanged: (val) {
                        setState(() {
                          selectedSalaryRange = val.toString();
                        });
                      },
                    ),
                    16.verticalSpace,
                    AppTextField(
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
                      lines: 4,
                      title: "Work Location",
                      hint: "Enter your work address",
                      controller: workLocationController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "workLocation", value: val),
                      ),
                    ),
                    16.verticalSpace,

                    AppTextField(
                      lines: 4,
                      title: "Native Location",
                      hint: "Enter your Native address",
                      controller: workLocationController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "Native", value: val),
                      ),
                    ),
                    16.verticalSpace,

                    // ✅ Buttons
                    SaveandNextButtons(
                      onNext: () {
                        router.goNamed(Routes.familyDetails.name);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
