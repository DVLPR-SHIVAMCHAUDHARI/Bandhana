import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_bloc.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_event.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return BlocProvider(
      create: (_) =>
          OtpBloc()..add(const OtpTimerStarted(20)), // start 30s timer
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackButton(),
                18.verticalSpace,
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Colors.black,
                    fontFamily: Typo.playfairSemiBold,
                  ),
                ).paddingHorizontal(10.w),

                8.verticalSpace,
                Text(
                  "We’ve sent a verification code to your email address. Please enter the code below to complete your account setup. +91 1234567890",
                  style: TextStyle(fontFamily: Typo.regular, fontSize: 16.sp),
                  textAlign: TextAlign.start,
                ).paddingHorizontal(10.w),

                40.verticalSpace,
                Align(
                  alignment: Alignment.center,
                  child: Pinput(
                    length: 4,
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    closeKeyboardWhenCompleted: true,
                    showCursor: false,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 24.sp,
                        fontFamily: Typo.bold,
                      ),
                      height: 61.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.primary.withOpacity(0.2),
                        border: Border.all(color: AppColors.otpGrey),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      height: 61.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.primary.withOpacity(0.2),
                        border: Border.all(color: AppColors.primary),
                      ),
                    ),
                    separatorBuilder: (index) => SizedBox(width: 16.w),
                  ),
                ),

                33.verticalSpace,
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.canResend
                              ? "You can resend now"
                              : "Resend code in ${state.remaining}s",
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: Typo.regular,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: state.canResend
                              ? () {
                                  // restart timer
                                  context.read<OtpBloc>().add(
                                    const OtpTimerStarted(30),
                                  );
                                  // call API here if needed
                                }
                              : null,
                          child: Text(
                            "Resend",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: state.canResend
                                      ? Colors.pink.shade400
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  decoration: state.canResend
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                  decorationColor: AppColors.primary,
                                ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                20.verticalSpace,
                PrimaryButton(
                  text: "Verify",
                  onPressed: () {
                    router.goNamed(Routes.welcome.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
