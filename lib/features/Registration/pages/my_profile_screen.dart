import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_bloc.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_event.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_state.dart';
import 'package:MilanMandap/features/Registration/pages/edit_profile_screen.dart';

import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';
import 'package:MilanMandap/features/master_apis/models/your_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final int centerIndex = 3;

  @override
  void initState() {
    super.initState();
    context.read<MasterBloc>().add(GetYourDetails());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileDetailApprovedBloc(),
      child: Scaffold(
        body: BlocBuilder<MasterBloc, MasterState>(
          buildWhen: (prev, curr) =>
              curr is GetYourDetailsLoadingState ||
              curr is GetYourDetailsLoadedState ||
              curr is GetYourDetailsErrorState,
          builder: (context, state) {
            if (state is GetYourDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetYourDetailsErrorState) {
              return Center(
                child: Text("Failed to load profile: ${state.message}"),
              );
            } else if (state is GetYourDetailsLoadedState) {
              final YourDetailModel user = state.yourDetail;

              // Initialize ProfileDetailBloc with this user
              final profileBloc = context.read<ProfileDetailApprovedBloc>();
              profileBloc.add(
                GetUserDetailById(user.profileDetails!.id.toString()),
              );

              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainImage(context, user),
                        Transform.translate(
                          offset: Offset(0, -40),
                          child: _buildAvatarStack(context, user),
                        ),
                        _buildProfileDetails(user),
                        SizedBox(height: 120.h),
                      ],
                    ),
                  ),
                  // Top AppBar
                  Positioned(
                    top: 50.h,
                    left: 16.w,
                    right: 16.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => router.goNamed(Routes.homescreen.name),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),

        // Bottom Button
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      router.pushNamed(Routes.editProfile.name);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 24.r,
                            offset: const Offset(4, 8),
                            color: AppColors.primaryOpacity,
                          ),
                        ],
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: Typo.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainImage(BuildContext context, YourDetailModel user) {
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    return BlocBuilder<ProfileDetailApprovedBloc, ProfileDetailApprovedState>(
      builder: (context, state) {
        String imageUrl = avatars[centerIndex] ?? '';
        int highlightedIndex = centerIndex;

        if (state is SwitchImageState) {
          highlightedIndex = state.selectedIndex;
          imageUrl = state.avatars[highlightedIndex]['url'];
        }

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 650.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(height: 500.h, color: Colors.grey[200]),
              errorWidget: (_, __, ___) =>
                  Container(height: 500.h, color: Colors.grey),
            ),
            Container(
              height: 570,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 50.verticalSpace,
                  Text(
                    "${user.profileDetails!.fullname}, ${user.profileSetup!.age}",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: Typo.playfairDisplayRegular,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    "${user.profileSetup!.professionName} · ${user.profileDetails!.districtName}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                  ),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    children: List.generate(
                      user.profileDetails!.hobbies!.length,
                      (index) => _buildTag(
                        "#${user.profileDetails!.hobbies![index].hobbyName}",
                      ),
                    ),
                  ),
                  60.verticalSpace,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarStack(BuildContext context, YourDetailModel user) {
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    return SizedBox(
      height: 100.h,
      child: BlocBuilder<ProfileDetailApprovedBloc, ProfileDetailApprovedState>(
        builder: (context, state) {
          List<Map<String, dynamic>> avatarPositions = List.generate(
            avatars.length,
            (index) {
              final screenWidth = MediaQuery.sizeOf(context).width;

              double top;
              double? left;
              double? right;
              double size;

              // 🎯 Scale top offsets proportionally
              if (index == centerIndex) {
                top = -0.15 * screenWidth; // about -5% of width
              } else if (index == 1 || index == 2) {
                top = -0.02 * screenWidth; // about -2% of width
              } else {
                top = 0.03 * screenWidth; // about +3% of width
              }

              // 🎯 Scale horizontal positions
              switch (index) {
                case 0:
                  left = 0.0;
                  break;
                case 1:
                  left = screenWidth * 0.15;
                  break;
                case 2:
                  right = screenWidth * 0.15;
                  break;
                case 3:
                  left = screenWidth * 0.32;
                  break;
                case 4:
                  right = 0.0;
                  break;
                default:
                  break;
              }

              // 🎯 Scalable avatar sizes
              size = index == centerIndex
                  ? 0.38 * screenWidth
                  : 0.25 * screenWidth;

              return {
                'index': index,
                'url': avatars[index] ?? '',
                'top': top,
                'left': left,
                'right': right,
                'size': size,
              };
            },
          );

          int highlightedIndex = centerIndex;
          if (state is SwitchImageState) {
            highlightedIndex = state.selectedIndex;
            avatarPositions = state.avatars.map((avatar) {
              int idx = avatar['index'];
              return {
                ...avatar,
                'top': idx == centerIndex
                    ? -40.0
                    : idx == 1 || idx == 2
                    ? -15.0
                    : 20.0,
                'size': idx == centerIndex ? 152.h : 100.h,
              };
            }).toList();
          }

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: List.generate(avatarPositions.length, (index) {
              final avatar = avatarPositions[index];
              return Positioned(
                top: avatar['top'],
                left: avatar['left'],
                right: avatar['right'],
                child: GestureDetector(
                  onTap: () {
                    if (index != highlightedIndex) {
                      context.read<ProfileDetailApprovedBloc>().add(
                        SwitchImageEvent(index, avatarPositions),
                      );
                    }
                  },
                  child: Container(
                    height: avatar['size'],
                    width: avatar['size'],
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: index == highlightedIndex
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(avatar['url']),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetails(YourDetailModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- ABOUT ----------
                Text(
                  "About ${user.profileDetails?.fullname?.split(' ').first ?? ''}",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: Typo.playfairBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                13.verticalSpace,
                Text(
                  user.profileSetup?.bio ?? '-',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: Typo.regular,
                    color: Colors.black87,
                  ),
                ),

                // ---------- PERSONAL DETAILS ----------
                _sectionCard("Personal Details", [
                  _profileDetail(
                    "Full Name",
                    user.profileDetails?.fullname ?? '-',
                  ),
                  _profileDetail(
                    "Gender",
                    user.profileDetails?.genderName ?? '-',
                  ),
                  _profileDetail(
                    "Marital Status",
                    user.profileDetails?.maritalStatusName ?? '-',
                  ),
                  _profileDetail(
                    "Religion",
                    user.profileDetails?.religionName ?? '-',
                  ),
                  _profileDetail(
                    "Caste",
                    user.profileDetails?.casteName ?? '-',
                  ),
                  _profileDetail("Kul", user.profileDetails?.kul ?? '-'),
                  _profileDetail(
                    "Birth Place",
                    user.profileDetails?.birthPlace ?? '-',
                  ),
                  _profileDetail(
                    "Birth Time",
                    (user.profileDetails?.birthTime != null)
                        ? user.profileDetails!.birthTime!
                              .split(':')
                              .take(2)
                              .join(':')
                        : '-',
                  ),
                  _profileDetail(
                    "Birth Date",
                    user.profileDetails?.dateOfBirth ?? '-',
                  ),
                  _profileDetail(
                    "Blood Group",
                    user.profileDetails?.bloodGroupName ?? '-',
                  ),
                  _profileDetail(
                    "Zodiac Sign",
                    user.profileDetails?.zodiacName ?? '-',
                  ),
                  _profileDetail(
                    "Disability",
                    user.profileDetails?.disablity ?? '-',
                  ),
                  _profileDetail(
                    "Nationality",
                    user.profileDetails?.nationalityName ?? '-',
                  ),
                  _profileDetail(
                    "Hobbies",
                    user.profileDetails?.hobbies
                            ?.map((e) => e.hobbyName)
                            .join(', ') ??
                        '-',
                  ),
                ], icon: Icons.person),

                // ---------- PROFESSION & ACADEMICS ----------
                _sectionCard("Profession & Academics", [
                  _profileDetail(
                    "Profession",
                    user.profileSetup?.professionName ?? '-',
                  ),
                  _profileDetail(
                    "Education",
                    user.profileSetup?.educationName ?? '-',
                  ),
                  _profileDetail(
                    "Salary",
                    user.profileSetup?.salaryName ?? '-',
                  ),
                  _profileDetail(
                    "Height",
                    "${user.profileSetup?.height ?? '-'} cm",
                  ),
                  _profileDetail(
                    "Work Location",
                    user.profileSetup?.workLocation ?? '-',
                  ),
                ], icon: Icons.school),

                // ---------- FAMILY DETAILS ----------
                _sectionCard("Family Details", [
                  _profileDetail(
                    "Father's Name",
                    user.familyDetails?.fathersName ?? '-',
                  ),
                  _profileDetail(
                    "Mother's Name",
                    user.familyDetails?.mothersName ?? '-',
                  ),
                  _profileDetail(
                    "Father's Occupation",
                    user.familyDetails?.fathersOccupation ?? '-',
                  ),
                  _profileDetail(
                    "Mother's Occupation",
                    user.familyDetails?.mothersOccupation ?? '-',
                  ),
                  _profileDetail(
                    "Family Type",
                    user.familyDetails?.familyTypeName ?? '-',
                  ),
                  _profileDetail(
                    "Family Status",
                    user.familyDetails?.familyStatusName ?? '-',
                  ),
                  _profileDetail(
                    "Family Values",
                    user.familyDetails?.familyValuesName ?? '-',
                  ),
                  _profileDetail(
                    "No. of Brothers",
                    "${user.familyDetails?.noOfBrothers ?? 0}",
                  ),
                  _profileDetail(
                    "No. of Sisters",
                    "${user.familyDetails?.noOfSisters ?? 0}",
                  ),
                  _profileDetail(
                    "Maternal Uncle's Name",
                    user.familyDetails?.maternalUncleMamasName ?? '-',
                  ),
                  _profileDetail(
                    "Maternal Uncle's Village",
                    user.familyDetails?.maternalUncleMamasVillage ?? '-',
                  ),
                  _profileDetail(
                    "Mamas Kul / Clan",
                    user.familyDetails?.mamasKulClan ?? '-',
                  ),
                  _profileDetail(
                    "Relatives Family Surnames",
                    user.familyDetails?.relativesFamilySurnames ?? '-',
                  ),
                ], icon: Icons.family_restroom),

                // ---------- HOBBIES ----------
                _sectionCard("Hobbies", [
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      user.profileDetails!.hobbies!.length,
                      (index) => Card(
                        color: AppColors.primaryLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          user.profileDetails!.hobbies![index].hobbyName!,
                          style: TextStyle(
                            fontFamily: Typo.medium,
                            fontSize: 16.sp,
                          ),
                        ).padding(EdgeInsets.all(12.w)),
                      ),
                    ),
                  ),
                ], icon: Icons.sports_basketball),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: Typo.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              style: TextStyle(fontFamily: Typo.medium, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontFamily: Typo.medium,
        ),
      ),
    );
  }
}

Widget _sectionCard(String title, List<Widget> children, {IconData? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      20.verticalSpace,
      Row(
        children: [
          if (icon != null) Icon(icon, size: 22),
          if (icon != null) 8.widthBox,
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: Typo.playfairSemiBold,
            ),
          ),
        ],
      ),
      12.verticalSpace,
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    ],
  );
}
