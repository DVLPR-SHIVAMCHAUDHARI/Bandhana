import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/const/app_colors.dart';
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
          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    state.currentPage.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),

                // Content
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 420.h,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        25.heightBox,
                        SvgPicture.asset(
                          Urls.icOnboardingLogo,
                          height: 44.h,
                          width: 63.w,
                        ),
                        4.heightBox,
                        Text(
                          state.currentPage.title,
                          style: TextStyle(
                            fontSize: 32.sp,

                            color: AppColors.primary,
                            fontFamily: Typo.playfairBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        20.heightBox,
                        Text(
                          state.currentPage.subtitle,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: Typo.medium,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        40.heightBox,

                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            OnboardingRepo.pages.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: state.currentIndex == index ? 32.w : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: state.currentIndex == index
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        40.heightBox,

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: Size(double.infinity.w, 58.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          onPressed: () {
                            state.currentIndex ==
                                    OnboardingRepo.pages.length - 1
                                ? router.goNamed(Routes.signup.name)
                                : context.read<OnboardingBloc>().add(
                                    NextPageEvent(),
                                  );
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
                        30.heightBox,
                      ],
                    ),
                  ),
                ),

                // Skip button
                Positioned(
                  top: 40.w,
                  right: 16.w,
                  child: state.currentIndex == 2
                      ? SizedBox.shrink()
                      : TextButton(
                          onPressed: () {
                            context.read<OnboardingBloc>().add(SkipEvent());
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(fontSize: 16, color: Colors.black),
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
