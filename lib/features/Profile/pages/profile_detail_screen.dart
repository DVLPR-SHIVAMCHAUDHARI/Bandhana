import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';

import 'package:bandhana/features/Profile/bloc/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
import 'package:bandhana/features/Profile/model/user_detail_model.dart';
import 'package:bandhana/features/Profile/widgets/compatibility_check_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailedScreen extends StatelessWidget {
  const ProfileDetailedScreen({
    super.key,
    required this.mode,
    required this.id,
    required this.match,
  });

  final String mode;
  final String id;
  final String match;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileDetailBloc()..add(GetUserDetailById(id)),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
          builder: (context, state) {
            if (state is ProfileDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileDetailError) {
              return Center(child: Text(state.message!));
            }

            UserDetailModel? user;

            if (state is ProfileDetailLoaded) {
              user = state.user;
            } else if (state is SwitchImageState) {
              user = state.user;
            } else if (state is FavoriteToggledState) {
              user = state.user;
            }

            if (user != null) {
              return SingleChildScrollView(
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
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: buildBottombar(context),
      ),
    );
  }

  // --- buildBottombar ---

  SafeArea buildBottombar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: mode == 'viewOther'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CompatibilityDialog(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 14.h,
                        ),
                      ),
                      child: Text(
                        "Check Match",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: Typo.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  10.widthBox,
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ProfileType.normal.name == "normal"
                            ? router.pushNamed(Routes.choosePlan.name)
                            : router.pushNamed(Routes.messageRequested.name);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 24.r,
                              offset: Offset(4, 8),
                              color: AppColors
                                  .primaryOpacity, // Assuming this is defined
                            ),
                          ],
                          gradient: AppColors
                              .buttonGradient, // Assuming this is defined
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 14.h,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Show Interest",
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
              )
            : InkWell(
                onTap: () {
                  ProfileType.normal.name == "normal"
                      ? router.pushNamed(Routes.choosePlan.name)
                      : router.pushNamed(Routes.chatList.name);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24.r,
                        offset: Offset(4, 8),
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
                    "Accept Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // --- _buildMainImage (FIXED isFavorite LOGIC) ---
  Widget _buildMainImage(BuildContext context, UserDetailModel user) {
    // 5 profile URLs
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    return BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
      builder: (context, state) {
        String imageUrl;
        int centerIndex = 3; // default center avatar

        // ✅ FIX: Initialize isFavorite to false as it is not dependent on the UserDetailModel yet.
        bool isFavorite = false;

        if (state is ProfileDetailLoaded) {
          isFavorite = state.isFavorite;
        } else if (state is FavoriteToggledState) {
          isFavorite = state.isFavorite;
        } else if (state is SwitchImageState) {
          isFavorite = state.isFavorite;
        }

        // Determine the image URL based on the latest state
        if (state is SwitchImageState) {
          // If in SwitchImageState, use the URL array from the state
          imageUrl = state.avatars[centerIndex]['url'];
        } else {
          // Otherwise, use the original image at the center position
          imageUrl = avatars[centerIndex] ?? '';
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

            // Gradient Overlay and Content
            Container(
              height: 550.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            mode == ProfileMode.viewOther.name
                                ? router.goNamed(Routes.homescreen.name)
                                : router.goNamed(Routes.request.name);
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                      ),
                      // Favorite Button
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            context.read<ProfileDetailBloc>().add(
                              ToggleFavoriteEvent(),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: isFavorite ? Colors.pink : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  200.verticalSpace,

                  // Name + Age
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

                  // Occupation + Location
                  Text(
                    "${user.profileSetup!.professionName} · ${user.profileDetails!.district}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                  ),

                  12.verticalSpace,

                  // Tags
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

  // --- _buildAvatarStack ---
  Widget _buildAvatarStack(BuildContext context, UserDetailModel user) {
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    const int centerIndex = 3;

    return SizedBox(
      height: 160.h,
      child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
        builder: (context, state) {
          // Default positions
          List<Map<String, dynamic>> avatarPositions = List.generate(
            avatars.length,
            (index) => {
              'index': index,
              'url': avatars[index] ?? '',
              // Fan layout logic
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

          int highlightedIndex = centerIndex; // Default is the center image

          // Apply positions/urls from state if available
          if (state is SwitchImageState) {
            // Use the URLs updated by the BLoC
            avatarPositions = state.avatars.map((avatar) {
              int idx = avatar['index'];
              return {
                ...avatar,
                // Re-apply the original fan layout top and size logic based on the index
                'top': idx == centerIndex
                    ? -40.0
                    : idx == 1 || idx == 2
                    ? -15.0
                    : 20.0,
                'left': avatarPositions.firstWhere(
                  (e) => e['index'] == idx,
                )['left'],
                'right': avatarPositions.firstWhere(
                  (e) => e['index'] == idx,
                )['right'],
                'size': idx == centerIndex ? 152.h : 100.h,
              };
            }).toList();
            // The highlighted index is always the center one after the swap
            highlightedIndex = centerIndex;
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
                      // Pass the list of current positions to the BLoC for swapping
                      context.read<ProfileDetailBloc>().add(
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
                        // Highlight the currently selected/center image
                        color: index == highlightedIndex
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: avatar['url'],
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.person, size: 40),
                      ),
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

  // --- _buildProfileDetails ---
  Widget _buildProfileDetails(UserDetailModel user) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "$match With Your Profile",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: Typo.playfairBold,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About ${user.profileDetails!.fullname!.split(' ').first}",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: Typo.playfairBold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  13.verticalSpace,
                  Text(
                    user.profileSetup!.bio!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: Typo.regular,
                      color: Colors.black87,
                    ),
                  ),
                  35.verticalSpace,
                  _profileDetail(
                    "Profession",
                    user.profileSetup!.professionName!,
                  ),
                  _profileDetail(
                    "Education",
                    user.profileSetup!.educationName!,
                  ),
                  _profileDetail(
                    "Religion",
                    user.profileDetails!.religionName!,
                  ),
                  _profileDetail("Caste", user.profileDetails!.casteName!),
                  _profileDetail(
                    "Location",
                    user.profileDetails!.districtName!,
                  ),
                  _profileDetail(
                    "Job Location",
                    user.profileDetails!.districtName!,
                  ),
                  _profileDetail(
                    "Birth Place",
                    user.profileDetails!.birthPlace!,
                  ),
                  _profileDetail("Birth Time", user.profileDetails!.birthTime!),
                  _profileDetail("Zodiac", user.profileDetails!.zodiacName!),
                  _profileDetail(
                    "Language Spoken",
                    user.profileDetails!.motherTongueName!,
                  ),
                  _profileDetail("Height", "${user.profileSetup!.height} cm"),
                  _profileDetail(
                    "Marital Status",
                    user.profileDetails!.maritalStatusName!,
                  ),
                  _profileDetail("Match Percentage", match),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods ---
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
