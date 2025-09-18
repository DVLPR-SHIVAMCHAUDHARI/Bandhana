import 'dart:io';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
import 'package:bandhana/features/master_apis/models/profile_setup_model.dart';
import 'package:bandhana/features/master_apis/models/salary_model.dart';
import 'package:bandhana/features/master_apis/models/user_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  SalaryModel? selectedSalaryRange;
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  var ageController = TextEditingController();
  var heightController = TextEditingController();
  var permanentAddressController = TextEditingController();
  var workAddressController = TextEditingController();
  var nativeAddressController = TextEditingController();

  ProfessionModel? selectedProfession;
  EducationModel? selectedEducation;

  // local copies of API models (filled when MasterBloc emits)
  UserDetailModel? _profileDetail;
  ProfileSetupModel? _profileSetup;

  @override
  void initState() {
    super.initState();
    final masterBloc = context.read<MasterBloc>();
    // call APIs once
    masterBloc.add(GetProfileDetailsEvent());
    masterBloc.add(GetProfileSetupEvent());
    masterBloc.add(GetProfessionEvent());
    masterBloc.add(GetSalaryEvent());
    masterBloc.add(GetEducationEvent());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    ageController.dispose();
    heightController.dispose();
    permanentAddressController.dispose();
    workAddressController.dispose();
    nativeAddressController.dispose();
    super.dispose();
  }

  /// Update form controllers from API models (safe: called from BlocListener)
  void _applyApiDataToControllers() {
    if (_profileDetail != null) {
      fullNameController.text = _profileDetail!.fullname ?? "";
      phoneController.text = _profileDetail!.contactNumber ?? "";
    }
    if (_profileSetup != null) {
      bioController.text = _profileSetup!.bio ?? "";
      ageController.text = _profileSetup!.age?.toString() ?? "";
      heightController.text = _profileSetup!.height?.toString() ?? "";
      permanentAddressController.text = _profileSetup!.permanentLocation ?? "";
      workAddressController.text = _profileSetup!.workLocation ?? "";
      // nativeAddressController.text = _profileSetup!.nativeLocation ?? "";

      if (_profileSetup!.education != null) {
        selectedEducation = EducationModel(education: _profileSetup!.education);
      }
      if (_profileSetup!.profession != null) {
        selectedProfession = ProfessionModel(
          profession: _profileSetup!.profession,
        );
      }
      if (_profileSetup!.salary != null) {
        selectedSalaryRange = SalaryModel(salaryRange: _profileSetup!.salary);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileSetupBloc = context.read<ProfileSetupBloc>();

    return MultiBlocListener(
      listeners: [
        // Listen to MasterBloc to capture profile detail & setup responses
        BlocListener<MasterBloc, MasterState>(
          listener: (context, state) {
            if (state is GetProfileDetailsLoadedState) {
              _profileDetail = state.profileDetail;
              _applyApiDataToControllers();
              setState(() {}); // rebuild to show name/district if needed
            } else if (state is GetProfileSetupLoadedState) {
              _profileSetup = state.profileSetup;
              _applyApiDataToControllers();
              setState(() {}); // rebuild to show images / prefilled values
            }
          },
        ),

        // Optionally listen to ProfileSetupBloc events (e.g., picks) for side-effects
        BlocListener<ProfileSetupBloc, ProfileSetupState>(
          listener: (context, state) {
            // we rebuild UI via BlocBuilder below; nothing extra required here
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => router.goNamed(Routes.homescreen.name),
          ),
          centerTitle: false,
          title: const Text(
            "My Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (context, setupState) {
            // picked images from ProfileSetupBloc (local / selected)
            List pickedImages = [];
            if (setupState is PickImageLoadedState)
              pickedImages = setupState.images;

            // server gallery images from _profileSetup (profileUrl2..profileUrl5)
            final List<String> serverGallery = [
              _profileSetup?.profileUrl2,
              _profileSetup?.profileUrl3,
              _profileSetup?.profileUrl4,
              _profileSetup?.profileUrl5,
            ].whereType<String>().toList();

            // main image candidate: priority -> pickedImages[0] -> server profileUrl1 -> null
            ImageProvider? mainImageProvider;
            if (pickedImages.isNotEmpty) {
              try {
                mainImageProvider = FileImage(File(pickedImages[0].path));
              } catch (_) {
                mainImageProvider = null;
              }
            } else if (_profileSetup?.profileUrl1 != null) {
              mainImageProvider = CachedNetworkImageProvider(
                _profileSetup!.profileUrl1!,
              );
            } else {
              mainImageProvider = null;
            }

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER area: gradient + avatar + name + district
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 100.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40.r),
                            bottomRight: Radius.circular(40.r),
                          ),
                          color: AppColors.primary,
                        ),
                      ),

                      // Avatar
                      Positioned(
                        left: 38.w,
                        top: 37.h,
                        child: CircleAvatar(
                          radius: 48.r,
                          backgroundColor: Colors.white,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 46.r,
                                backgroundImage: mainImageProvider,
                                child: mainImageProvider == null
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    // open picker to replace/add images
                                    profileSetupBloc.add(
                                      PickImageEvent(
                                        limit: 5 - pickedImages.length,
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 15,
                                    child: SvgPicture.asset(
                                      Urls.icEdit,
                                      height: 14.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Name + district (from _profileDetail if available, fallback to localDb)
                      Positioned(
                        top: 47.h,
                        left: 150.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profileDetail?.fullname ??
                                  localDb.getUserData()?.fullname ??
                                  "",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _profileDetail?.district ?? "Loading...",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  50.verticalSpace,

                  // Form fields and gallery (kept same components)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Partner expectations",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 22.sp,
                          fontFamily: Typo.semiBold,
                        ),
                      ),
                      16.verticalSpace,
                      AppTextField(
                        title: "Name",
                        hint: "John Doe",
                        controller: fullNameController,
                      ),
                      16.verticalSpace,
                      PhoneNumberField(
                        title: "Mobile No.",
                        controller: phoneController,
                      ),
                      16.verticalSpace,
                      Text(
                        "Upload Photos",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontFamily: Typo.bold,
                        ),
                      ),
                      10.verticalSpace,

                      // Gallery: fill with pickedImages first, then serverGallery, then add slots
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(5, (index) {
                            // If we have a picked image for this slot:
                            if (index < pickedImages.length) {
                              final p = pickedImages[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: 64.w,
                                    height: 58.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(File(p.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () => profileSetupBloc.add(
                                        RemoveImageEvent(index),
                                      ),
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
                            }

                            // If picked images exhausted, show server gallery (offset = index - pickedImages.length)
                            final serverIndex = index - pickedImages.length;
                            if (serverIndex >= 0 &&
                                serverIndex < serverGallery.length) {
                              final url = serverGallery[serverIndex];
                              return Container(
                                width: 64.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(url),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }

                            // Otherwise show add button
                            return GestureDetector(
                              onTap: () => profileSetupBloc.add(
                                PickImageEvent(limit: 5 - pickedImages.length),
                              ),
                              child: Container(
                                width: 64.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      16.verticalSpace,

                      // Bio etc (prefilled values are already applied to controllers via listener)
                      AppTextField(
                        title: "About You(Bio)",
                        hint: "Write a short bio about yourself",
                        controller: bioController,
                        lines: 4,
                      ),
                      16.verticalSpace,
                      AppTextField(
                        title: "Age",
                        hint: "Enter your age",
                        controller: ageController,
                      ),
                      16.verticalSpace,
                      AppTextField(
                        title: "Height",
                        hint: "Enter your height",
                        controller: heightController,
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
                              value: selectedEducation?.education,
                              onChanged: (v) {
                                final selected = state.educations.firstWhere(
                                  (e) => e.education == v,
                                );
                                setState(() => selectedEducation = selected);
                              },
                            );
                          } else if (state is GetEducationErrorState) {
                            return Text("Error: ${state.message}");
                          }
                          return const SizedBox.shrink();
                        },
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
                                final selected = state.professions.firstWhere(
                                  (e) => e.profession == v,
                                );
                                setState(() => selectedProfession = selected);
                              },
                            );
                          } else if (state is GetProfessionErrorState) {
                            return Text("Error: ${state.message}");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      16.verticalSpace,

                      // Salary Dropdown
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
                              value: selectedSalaryRange?.salaryRange,
                              onChanged: (v) {
                                final selected = state.salarys.firstWhere(
                                  (e) => e.salaryRange == v,
                                );
                                setState(() => selectedSalaryRange = selected);
                              },
                            );
                          } else if (state is GetSalaryErrorState) {
                            return Text("Error: ${state.message}");
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      16.verticalSpace,

                      // Locations
                      AppTextField(
                        lines: 4,
                        title: "Permanent Location",
                        hint: "Enter your permanent address",
                        controller: permanentAddressController,
                        onChanged: (val) => profileSetupBloc.add(
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
                        controller: workAddressController,
                        onChanged: (val) => profileSetupBloc.add(
                          UpdateFieldEvent(field: "workLocation", value: val),
                        ),
                      ),
                      16.verticalSpace,
                      AppTextField(
                        lines: 4,
                        title: "Native Location",
                        hint: "Enter your Native address",
                        controller: nativeAddressController,
                        onChanged: (val) => profileSetupBloc.add(
                          UpdateFieldEvent(field: "nativeLocation", value: val),
                        ),
                      ),
                      100.verticalSpace,
                    ],
                  ).paddingHorizontal(24.w),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
            child: SizedBox(
              height: 58.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle proceed / save profile setup (call repo via bloc)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Save & Update",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
