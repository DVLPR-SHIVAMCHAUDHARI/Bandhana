import 'dart:io';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/BasicCompatiblity/repositories/basic_compatiblity_repository.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_state.dart';
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
                                bloc.add(PickImageEvent());
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
                          Text(
                            "John Doe",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Nashik division Maharastra",
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
                    AppTextField(title: "Name", hint: "John Doe"),
                    16.verticalSpace,
                    AppTextField(title: "Mobile No.", hint: "+91 1234567890"),
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
                            onTap: () => bloc.add(PickImageEvent()),
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
                      lines: 4,
                    ),
                    16.verticalSpace,
                    AppTextField(title: "Age", hint: "Enter your age"),
                    16.verticalSpace,
                    AppTextField(title: "Height", hint: "Enter your height"),
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

                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "workLocation", value: val),
                      ),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      lines: 4,
                      title: "Native Location",
                      hint: "Enter your Native address",

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
      bottomNavigationBar: Container(
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
        ).marginVertical(10),
      ),
    );
  }
}
