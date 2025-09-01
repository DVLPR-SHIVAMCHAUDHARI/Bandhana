import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Urls.icBandhanaNameLogo,
                      height: 66.h,
                      color: Colors.black,
                    ),
                    8.horizontalSpace,
                    SvgPicture.asset(Urls.icSplashLogo, height: 61.h),
                  ],
                ),
                104.verticalSpace,

                Text(
                  "Sign in",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 32.sp,
                    fontFamily: Typo.playfairSemiBold,
                  ),
                ),

                40.verticalSpace,

                PhoneNumberField(
                  title: "Enter Mobile No.",
                  controller: phoneController,
                  initialCountryCode: "+91",
                ),
                24.verticalSpace,

                PrimaryButton(
                  text: "Sign In",
                  onPressed: () {
                    router.goNamed(Routes.homescreen.name);
                  },
                ),

                16.verticalSpace,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        router.goNamed(Routes.signup.name);
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.pink.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
