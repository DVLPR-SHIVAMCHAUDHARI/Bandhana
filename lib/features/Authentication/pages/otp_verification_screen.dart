import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_bloc.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_event.dart';
import 'package:bandhana/features/Authentication/Bloc/OtpBloc/otp_state.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_bloc.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_event.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String number;
  final String prev;

  OtpVerificationScreen({super.key, required this.number, required this.prev});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              OtpBloc()..add(const OtpTimerStarted(60)), // start 30s timer
        ),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButton(
                    onPressed: () {
                      prev == "signin"
                          ? router.goNamed(Routes.signin.name)
                          : router.goNamed(Routes.signup.name);
                    },
                  ),
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
                    "We’ve sent a verification code to $number. Please enter the code below to complete your account setup.",
                    style: TextStyle(fontFamily: Typo.regular, fontSize: 16.sp),
                    textAlign: TextAlign.start,
                  ).paddingHorizontal(10.w),
                  10.verticalSpace,
                  Row(
                    children: [
                      Text(
                        "Wrong number?",
                        style: TextStyle(
                          fontFamily: Typo.regular,
                          fontSize: 16.sp,
                        ),
                      ).paddingHorizontal(10.w),
                      InkWell(
                        onTap: () {
                          router.goNamed(Routes.signin.name);
                        },
                        child: Text(
                          "edit",
                          style: TextStyle(
                            fontFamily: Typo.semiBold,
                            fontSize: 16.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  40.verticalSpace,
                  Align(
                    alignment: Alignment.center,
                    child: Pinput(
                      enableSuggestions: true,
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
                                    context.read<OtpBloc>().add(
                                      OtpTimerStarted(60),
                                    );
                                    context.read<AuthBloc>().add(
                                      ResendOtpEvent(phone: number),
                                    );
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
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is VerifyOtpLoadedState) {
                        final user = localDb.getUserData();
                        if (LocalDbService().checkUserComesFirstTime() ==
                            true) {
                          router.goNamed(Routes.welcome.name);
                          return;
                        } else if (user != null) {
                          if (user.profileDetails == 0) {
                            router.goNamed(Routes.register.name);
                            return;
                          } else if (user.profileSetup == 0) {
                            router.goNamed(Routes.profilesetup.name);
                            return;
                          } else if (user.documentVerification == 0) {
                            router.goNamed(Routes.docVerification.name);
                            return;
                          } else if (user.partnerExpectations == 0) {
                            router.goNamed(Routes.compatablity1.name);
                            return;
                          } else if (user.partnerLifeStyle == 0) {
                            router.goNamed(Routes.compatablity2.name);
                            return;
                          } else if (user.familyDetails == 0) {
                            router.goNamed(Routes.familyDetails.name);
                            return;
                          }

                          /// ✅ All steps completed
                          router.goNamed(Routes.homescreen.name);
                          return;
                        }
                      }
                      if (state is VerifyOtpErrorState) {
                        final msg =
                            state.message?.toString() ?? "Error verifying OTP";
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                    builder: (context, state) {
                      return state is VerifyOtpLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: "Verify",
                              onPressed: () {
                                if (otpController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter the OTP"),
                                    ),
                                  );
                                  return;
                                }
                                if (otpController.text.length < 4) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("OTP must be 4 digits"),
                                    ),
                                  );
                                  return;
                                }

                                context.read<AuthBloc>().add(
                                  VerifyOtpEvent(
                                    phone: number,
                                    otp: otpController.text,
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
