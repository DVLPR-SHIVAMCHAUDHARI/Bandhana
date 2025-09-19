import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Home/bloc/home_bloc.dart';
import 'package:bandhana/features/Home/bloc/home_event.dart';
import 'package:bandhana/features/Home/bloc/home_state.dart';
import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
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
  });

  final String mode;
  final String id;

  @override
  Widget build(BuildContext context) {
    // Fetch users if not already fetched
    context.read<HomeBloc>().add(FetchUsersEvent());

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ProfileDetailBloc())],
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is FetchUsersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FetchUserFailureState) {
              return Center(child: Text(state.message!));
            } else if (state is FetchUserLoadedState) {
              // Find user by ID
              final HomeUserModel user = state.list.firstWhere(
                (u) => u.userId.toString() == id,
                orElse: () => state.list.first,
              );

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

        // Bottom Buttons
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: mode == ProfileMode.viewOther.name
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
                            router.pushNamed(Routes.messageRequested.name);
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
        ),
      ),
    );
  }

  // 🔹 Main Image
  // 🔹 Main Image
  Widget _buildMainImage(BuildContext context, HomeUserModel user) {
    // 5 profile URLs
    final List<String?> avatars = [
      user.profileUrl1,
      user.profileUrl2,
      user.profileUrl3,
      user.profileUrl4,
      user.profileUrl5,
    ];

    return BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
      builder: (context, state) {
        String imageUrl;
        int centerIndex = 3; // default center avatar

        if (state is SwitchImageState) {
          centerIndex = state.selectedIndex;
          imageUrl = state.avatars[centerIndex]['url'];
        } else {
          imageUrl = avatars[centerIndex] ?? '';
        }

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 500.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(height: 500.h, color: Colors.grey[200]),
              errorWidget: (_, __, ___) =>
                  Container(height: 500.h, color: Colors.grey),
            ),
            Container(
              height: 500.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7), // dark overlay bottom
                  ],
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
                      Align(
                        alignment: Alignment.topRight,
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
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.favorite_outline,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  200.verticalSpace,

                  // Pro user + Match
                  Row(
                    children: [
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 10.w,
                      //     vertical: 4.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.pinkAccent,
                      //     borderRadius: BorderRadius.circular(20.r),
                      //   ),
                      //   child: Text(
                      //     "☆ Pro User",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontFamily: Typo.medium,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 10.sp,
                      //     ),
                      //   ),
                      // ),
                      10.horizontalSpace,
                      Text(
                        "${user.matchPercentage}% Match With Your Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  10.verticalSpace,

                  // Name + Age
                  Text(
                    "${user.fullname}, ${user.age}",
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
                    "${user.profession} · ${user.district}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                  ),

                  12.verticalSpace,

                  // Tags
                  Wrap(
                    spacing: 8.w,
                    children: List.generate(
                      user.hobbies!.length,
                      (index) =>
                          _buildTag("#${user.hobbies![index].hobbyName}"),
                    ),
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
            // Back button, favorite icon, and text overlays...
          ],
        );
      },
    );
  }

  // 🔹 Avatar Stack
  Widget _buildAvatarStack(BuildContext context, HomeUserModel user) {
    final List<String?> avatars = [
      user.profileUrl1,
      user.profileUrl2,
      user.profileUrl3,
      user.profileUrl4,
      user.profileUrl5,
    ];

    final int centerIndex = 3;

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

          // Apply positions from state if available
          if (state is SwitchImageState) {
            // Keep the same fan layout for top & size
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
                    if (index != centerIndex) {
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
                        color:
                            state is SwitchImageState &&
                                state.selectedIndex == index
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

  // 🔹 Profile Details
  Widget _buildProfileDetails(HomeUserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "${user.matchPercentage}% Match With Your Profile",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              fontFamily: Typo.playfairBold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About ${user.fullname!.split(' ').first}",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: Typo.playfairBold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                13.verticalSpace,
                Text(
                  user.bio!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: Typo.regular,
                    color: Colors.black87,
                  ),
                ),
                35.verticalSpace,
                _profileDetail("Profession", user.profession!),
                _profileDetail("Education", user.education!),
                _profileDetail("Religion", user.religion!),
                _profileDetail("Caste", user.caste!),
                _profileDetail("Location", user.state!),
                _profileDetail("Job Location", user.workLocation!),
                _profileDetail("Birth Place", user.birthPlace!),
                _profileDetail("Birth Time", user.birthTime!),
                _profileDetail("Zodiac", user.zodiac!),
                _profileDetail("Language Spoken", user.motherTongue!),
                _profileDetail("Height", "${user.height} cm"),
                _profileDetail("Marital Status", user.maritalStatus!),
                _profileDetail("Preferred Match", "Between 33–38"),
                SizedBox(height: 80.h),
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
