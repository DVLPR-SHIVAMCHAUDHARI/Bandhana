import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
import 'package:bandhana/features/Profile/widgets/compatibility_check_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailedScreen extends StatelessWidget {
  const ProfileDetailedScreen({super.key, required this.mode});
  final String mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileDetailBloc()
        ..add(
          // 🔹 initialize first avatar
          SwitchImageEvent(0),
        ),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Main Image + overlay UI
              Stack(
                children: [
                  BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
                    builder: (context, state) {
                      if (state is SwitchImageState) {
                        return CachedNetworkImage(
                          imageUrl: state.avatars[state.selectedIndex]['url'],
                          imageBuilder: (context, imageProvider) => Container(
                            height: 500.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Container(height: 500.h, color: Colors.grey[200]),
                          errorWidget: (context, url, error) =>
                              Container(height: 500.h, color: Colors.grey),
                        );
                      }
                      return Container(
                        height: 500.h,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Text("something went wrong"),
                      );
                    },
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
                  Positioned(
                    top: 50.h,
                    left: 16.w,
                    child: IconButton(
                      onPressed: () => router.goNamed(Routes.homescreen.name),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: 50.h,
                    right: 16.w,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite_border, color: Colors.black),
                    ),
                  ),
                  Positioned(
                    bottom: 90.h,
                    left: 24.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Text(
                                "☆ Pro User",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "70% Match",
                              style: TextStyle(
                                fontFamily: Typo.medium,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Ananya Pandey",
                          style: TextStyle(
                            fontFamily: Typo.playfairSemiBold,
                            fontSize: 28.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Nashik, Age: 35",
                          style: TextStyle(
                            fontFamily: Typo.medium,

                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Fashion Designer",
                          style: TextStyle(
                            fontFamily: Typo.medium,

                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          "#Early Bird · Fitness Enthusiast · Non-Smoker",
                          style: TextStyle(
                            fontFamily: Typo.medium,

                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 🔹 Avatar Stack
              Transform.translate(
                offset: Offset(0, -40),
                child: SizedBox(
                  height: 120.h,
                  child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
                    builder: (context, state) {
                      if (state is SwitchImageState) {
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: List.generate(state.avatars.length, (
                            index,
                          ) {
                            final avatar = state.avatars[index];
                            return Positioned(
                              top: avatar['top'],
                              left: avatar['left'],
                              right: avatar['right'],
                              child: GestureDetector(
                                onTap: () {
                                  context.read<ProfileDetailBloc>().add(
                                    SwitchImageEvent(index),
                                  );
                                },
                                child: Container(
                                  height: avatar['size'],
                                  width: avatar['size'],
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: state.selectedIndex == index
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        avatar['url'],
                                      ),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),

              // 🔹 Profile details
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "70% Match With Your Profile",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: Typo.playfairBold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About Ananya",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: Typo.playfairBold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        13.verticalSpace,
                        Text(
                          "I believe in meaningful conversations, quiet mornings, and soulful connections. I value health, family traditions, and someone who respects individuality...",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: Typo.regular,
                            color: Colors.black87,
                          ),
                        ),
                        35.verticalSpace,
                        _profileDetail("Profession", "Fashion Designer"),
                        _profileDetail(
                          "Education",
                          "B.A. in Design, SNDT Mumbai",
                        ),
                        _profileDetail("Religion", "Hindu"),
                        _profileDetail("Caste", "Maratha"),
                        _profileDetail("Location", "Nashik"),
                        _profileDetail("Job Location", "Nashik"),
                        _profileDetail("Birth Place", "Nashik"),
                        _profileDetail("Birth Time", "01:01 PM"),
                        _profileDetail("Zodiac", "Gemini"),
                        _profileDetail(
                          "Language Spoken",
                          "Marathi, Hindi, English",
                        ),
                        _profileDetail("Height", "5'5\""),
                        _profileDetail("Marital Status", "Never Married"),
                        _profileDetail("Preferred Match", "Between 33–38"),
                        SizedBox(height: 80.h),
                      ],
                    ).padding(EdgeInsetsGeometry.all(24)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 🔹 Bottom Buttons
        bottomNavigationBar: Container(
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
                        : router.pushNamed(Routes.chat.name);
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
