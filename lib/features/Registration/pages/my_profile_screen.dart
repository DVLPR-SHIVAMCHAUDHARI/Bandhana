import 'dart:io';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:bandhana/features/BasicCompatiblity/repositories/basic_compatiblity_repository.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var bloc = context.read<MasterBloc>();

    bloc.add(GetProfessionEvent());
    bloc.add(GetSalaryEvent());
    bloc.add(GetEducationEvent());
    bloc.add(GetProfileDetailsEvent());
  }

  late UserDetailModel profileDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        builder: (context, state) {
          var bloc = context.read<ProfileSetupBloc>();
          List images = [];
          if (state is PickImageLoadedState) images = state.images;
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Positioned(
                      left: 38.w,
                      top: 37.h,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 48.r,
                        child: CircleAvatar(
                          backgroundImage: images.isNotEmpty
                              ? FileImage(File(images[0].path))
                              : CachedNetworkImageProvider(
                                  "https://m.media-amazon.com/images/M/MV5BMTY1MDUyMjI1N15BMl5BanBnXkFtZTYwMjg4MjA0._V1_FMjpg_UX1000_.jpg",
                                ),
                          radius: 46.r,

                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                bloc.add(
                                  PickImageEvent(limit: 5 - images.length),
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
                        ),
                      ),
                    ),
                    Positioned(
                      top: 47.h,
                      left: 150.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<MasterBloc, MasterState>(
                            builder: (context, state) {
                              if (state is GetProfileDetailsLoadingState) {
                                return CircularProgressIndicator();
                              } else if (state
                                  is GetProfileDetailsLoadedState) {
                                return Text(
                                  state.profileDetail.fullname!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text(
                                  localDb.getUserData()!.fullname,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                          BlocBuilder<MasterBloc, MasterState>(
                            builder: (context, state) {
                              if (state is GetProfileDetailsLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state
                                  is GetProfileDetailsLoadedState) {
                                return Text(
                                  state.profileDetail.district ?? "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                );
                              } else if (state is GetProfessionErrorState) {
                                return Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                50.verticalSpace,
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

                    Wrap(
                      spacing: 10,
                      children: List.generate(5, (index) {
                        if (index < images.length) {
                          return Stack(
                            children: [
                              Container(
                                width: 64.w,
                                height: 58.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(File(images[index].path)),
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
                        } else {
                          return GestureDetector(
                            onTap: () => bloc.add(
                              PickImageEvent(limit: 5 - images.length),
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
                        }
                      }),
                    ),

                    16.verticalSpace,
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
                    AppTextField(
                      lines: 4,
                      title: "Permanent Location",
                      hint: "Enter your permanent address",
                      controller: permanentAddressController,

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
                      controller: workAddressController,

                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "workLocation", value: val),
                      ),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      lines: 4,
                      title: "Native Location",
                      hint: "Enter your Native address",
                      controller: nativeAddressController,

                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "workLocation", value: val),
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
                // TODO: Handle proceed
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
    );
  }
}
