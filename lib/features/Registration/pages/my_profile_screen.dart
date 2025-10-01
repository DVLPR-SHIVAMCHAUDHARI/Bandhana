import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Profile/bloc_approved/profile_detail_approved_bloc.dart';
import 'package:bandhana/features/Profile/bloc_approved/profile_detail_approved_event.dart';
import 'package:bandhana/features/Profile/bloc_approved/profile_detail_approved_state.dart';

import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:bandhana/features/master_apis/models/your_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              height: 550.h,
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
                  50.verticalSpace,
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
                  40.verticalSpace,
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
      height: 160.h,
      child: BlocBuilder<ProfileDetailApprovedBloc, ProfileDetailApprovedState>(
        builder: (context, state) {
          List<Map<String, dynamic>> avatarPositions = List.generate(
            avatars.length,
            (index) => {
              'index': index,
              'url': avatars[index] ?? '',
              'top': index == centerIndex
                  ? -40.0
                  : index == 1 || index == 2
                  ? -20.0
                  : 20.0,
              'left': index == 0
                  ? 0.0
                  : index == 1
                  ? 60.w
                  : index == 2
                  ? null
                  : index == 3
                  ? MediaQuery.sizeOf(context).width * 0.32.w
                  : null,
              'right': index == 2
                  ? 60.w
                  : index == 4
                  ? 0.0
                  : null,
              'size': index == centerIndex ? 152.h : 100.h,
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
        SizedBox(height: 16.h),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                35.verticalSpace,
                _profileDetail(
                  "Profession",
                  user.profileSetup?.professionName ?? '-',
                ),
                _profileDetail(
                  "Education",
                  user.profileSetup?.educationName ?? '-',
                ),
                _profileDetail("Salary", user.profileSetup?.salaryName ?? '-'),
                _profileDetail(
                  "Height",
                  "${user.profileSetup?.height ?? '-'} cm",
                ),
                _profileDetail(
                  "Marital Status",
                  user.profileDetails?.maritalStatusName ?? '-',
                ),
                _profileDetail(
                  "Work Location",
                  user.profileSetup?.workLocation ?? '-',
                ),
                _profileDetail(
                  "Permanent Location",
                  user.profileSetup?.permanentLocation ?? '-',
                ),
                _profileDetail(
                  "Religion",
                  user.profileDetails?.religionName ?? '-',
                ),
                _profileDetail("Caste", user.profileDetails?.casteName ?? '-'),
                _profileDetail(
                  "Hobbies",
                  user.profileDetails!.hobbies!
                      .map((e) => e.hobbyName)
                      .toList()
                      .toString(),
                ),
                _profileDetail(
                  "Mother Tongue",
                  user.profileDetails?.motherTongueName ?? '-',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170.w,
            child: Text(
              title,
              style: TextStyle(fontFamily: Typo.bold, fontSize: 18.sp),
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              style: TextStyle(fontFamily: Typo.medium, fontSize: 18.sp),
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
