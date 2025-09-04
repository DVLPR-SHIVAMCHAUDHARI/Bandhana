import 'dart:developer';

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
  var selectedCode = '+91';
  var phoneController = TextEditingController();

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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vivah",
                      style: TextStyle(
                        fontFamily: Typo.kugile,
                        fontSize: 35.sp,
                        color: Color(0xff404040),
                      ),
                    ),
                    // SvgPicture.asset(
                    //   Urls.icBandhanaNameLogo,
                    //   height: 66.h,
                    //   color: Colors.black,
                    // ),
                    8.horizontalSpace,
                    SvgPicture.asset(Urls.icSplashLogo, height: 61.h),
                  ],
                ),
                Text(
                  "Bandhana",
                  style: TextStyle(
                    color: Color(0xff404040),

                    fontFamily: Typo.kugile,
                    fontSize: 38.sp,
                  ),
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
                  onCountryChanged: (p0) => selectedCode = p0,
                ),
                24.verticalSpace,

                PrimaryButton(
                  text: "Sign In",
                  onPressed: () {
                    final number = "$selectedCode${phoneController.text}";
                    log(number);

                    router.goNamed(
                      Routes.otp.name,
                      pathParameters: {"number": number, "prev": "signin"},
                    );
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
