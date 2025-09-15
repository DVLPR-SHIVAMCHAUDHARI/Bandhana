import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../data/onboarding_repo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;

          return Scaffold(
            body: Stack(
              children: [
                // Full screen background image
                Positioned.fill(
                  child: Image.asset(
                    state.currentPage.imagePath,
                    fit: BoxFit.cover,
                    height: screenHeight,
                    width: screenWidth,
                  ),
                ),

                // Bottom content container
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.45,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 25.h),

                        SvgPicture.asset(
                          Urls.icOnboardingLogo,
                          height: 44.h,
                          width: 63.w,
                        ),
                        SizedBox(height: 4.h),

                        Text(
                          state.currentPage.title,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: AppColors.primary,
                            fontFamily: Typo.playfairBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),

                        Text(
                          state.currentPage.subtitle,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: Typo.medium,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 40.h),

                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            OnboardingRepo.pages.length,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: state.currentIndex == index ? 32.w : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: state.currentIndex == index
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 58.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                            ),
                            onPressed: () {
                              if (state.currentIndex ==
                                  OnboardingRepo.pages.length - 1) {
                                router.goNamed(Routes.signup.name);
                              } else {
                                context.read<OnboardingBloc>().add(
                                  NextPageEvent(),
                                );
                              }
                            },
                            child: Text(
                              state.currentIndex ==
                                      OnboardingRepo.pages.length - 1
                                  ? "Finish"
                                  : state.currentIndex == 1
                                  ? "Next"
                                  : "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: Typo.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),

                // Skip button
                Positioned(
                  top: 40.h,
                  right: 16.w,
                  child: state.currentIndex == OnboardingRepo.pages.length - 1
                      ? SizedBox.shrink()
                      : TextButton(
                          onPressed: () =>
                              context.read<OnboardingBloc>().add(SkipEvent()),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
