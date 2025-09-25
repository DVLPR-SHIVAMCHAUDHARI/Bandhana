import 'dart:io';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_bloc.dart';
import 'package:bandhana/features/BasicCompatiblity/pages/basic_compablity_screen1.dart';
import 'package:bandhana/features/BasicCompatiblity/pages/basic_compablity_screen2.dart';

import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_event.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_state.dart';
import 'package:bandhana/features/Registration/pages/family_details_screen.dart';
import 'package:bandhana/features/Registration/pages/profile_setup_screen.dart';
import 'package:bandhana/features/Registration/pages/registration_screen.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/education_model.dart';
import 'package:bandhana/features/master_apis/models/profession_model.dart';
import 'package:bandhana/features/master_apis/models/profile_setup_model.dart';

import 'package:bandhana/features/master_apis/models/register_profile_model.dart.dart';
import 'package:bandhana/features/master_apis/models/your_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

List list = [
  {
    "icon": Icons.assignment_ind, // profile form
    "screen": RegistrationScreen(type: "edit"),
    "title": "Edit Registration",
  },
  {
    "icon": Icons.account_circle, // profile setup
    "screen": ProfileSetupScreen(type: "edit"),
    "title": "Edit Profile Setup",
  },
  {
    "icon": Icons.family_restroom, // family details
    "screen": FamilyDetailsScreen(),
    "title": "Edit Family Details",
  },
  {
    "icon": Icons.favorite, // basic compatibility
    "screen": BlocProvider(
      create: (context) => UserPreferencesBloc(),
      child: BasicCompablityScreen1(),
    ),
    "title": "Edit Basic Compatibility",
  },
  {
    "icon": Icons.favorite_border, // partner lifestyle
    "screen": BlocProvider(
      create: (context) => UserPreferencesBloc(),
      child: BasicCompablityScreen2(),
    ),
    "title": "Edit Partner Lifestyle Preference",
  },
];

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfessionModel? selectedProfession;
  EducationModel? selectedEducation;

  // local copies of API models (filled when MasterBloc emits)
  RegisterProfileModel? _profileDetail;
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
  Widget build(BuildContext context) {
    final profileSetupBloc = context.read<ProfileSetupBloc>();

    return MultiBlocListener(
      listeners: [
        // Listen to MasterBloc to capture profile detail & setup responses
        BlocListener<MasterBloc, MasterState>(
          listener: (context, state) {
            if (state is GetProfileDetailsLoadedState) {
              _profileDetail = state.profileDetail;
            } else if (state is GetProfileSetupLoadedState) {
              _profileSetup = state.profileSetup;
            }
          },
        ),

        BlocListener<ProfileSetupBloc, ProfileSetupState>(
          listener: (context, state) {},
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
            if (setupState is PickImageLoadedState) {
              pickedImages = setupState.images;
            }

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
                              _profileDetail?.districtName ?? "Loading...",
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
                  ...List.generate(
                    list.length,
                    (index) => customexpansiontile(
                      ic: list[index]["icon"],
                      title: list[index]["title"],
                      screen: list[index]["screen"],
                    ),
                  ),

                  // Profile setup section
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ExpansionTile customexpansiontile({ic, title, screen}) {
    return ExpansionTile(
      leading: Icon(ic),
      title: Text(title),
      children: [
        // 👇 Directly embed your Registration screen widget
        SizedBox(
          height: 500, // adjust so content fits
          child: screen,
        ),
      ],
    );
  }
}
