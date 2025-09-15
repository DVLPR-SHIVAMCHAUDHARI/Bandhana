import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_bloc.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_event.dart';
import 'package:bandhana/features/Authentication/Bloc/auth_bloc/auth_state.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCode = '+91';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInLoadedState) {
            final number = "$selectedCode${phoneController.text}";
            router.goNamed(
              Routes.otp.name,
              pathParameters: {"number": number, "prev": "signin"},
            );
          }

          if (state is SignUpErrorState) {
            final msg = state.message;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: BackgroundWidget(
                top: 232.h,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      40.verticalSpace,
                      // Logo row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vivah",
                            style: TextStyle(
                              fontFamily: Typo.kugile,
                              fontSize: 35.sp,
                              color: const Color(0xff404040),
                            ),
                          ),
                          8.horizontalSpace,
                          SvgPicture.asset(Urls.icSplashLogo, height: 61.h),
                        ],
                      ),
                      Text(
                        "Bandhana",
                        style: TextStyle(
                          color: const Color(0xff404040),
                          fontFamily: Typo.kugile,
                          fontSize: 38.sp,
                        ),
                      ),
                      104.verticalSpace,
                      Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontFamily: Typo.playfairSemiBold,
                        ),
                      ),
                      40.verticalSpace,
                      PhoneNumberField(
                        title: "Enter Mobile No.",
                        controller: phoneController,
                        initialCountryCode: "+91",
                        onCountryChanged: (code) => selectedCode = code,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your phone number";
                          }
                          if (value.trim().length < 10) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      24.verticalSpace,

                      // Sign In Button
                      state is SignInLoadingState
                          ? Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: "Sign In",
                              onPressed: () {
                                final number =
                                    "$selectedCode${phoneController.text}";
                                if (phoneController.text.isEmpty ||
                                    phoneController.text.length < 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Enter a valid phone number",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                // Trigger OTP send / Sign in event
                                context.read<AuthBloc>().add(
                                  SignInEvent(phone: number),
                                );
                                FocusScope.of(context).unfocus();
                              },
                            ),

                      16.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap: () => router.goNamed(Routes.signup.name),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.pink.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
