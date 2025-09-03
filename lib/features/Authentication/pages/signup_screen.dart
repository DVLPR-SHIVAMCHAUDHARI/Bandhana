import 'dart:developer';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';

import 'package:bandhana/core/const/typography.dart';

import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameField = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  var selectedCode = "+91";
  static bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24).w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              150.verticalSpace,
              // Logo row
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
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.sp,
                  fontFamily: Typo.playfairSemiBold,
                ),
              ),

              42.verticalSpace,

              AppTextField(title: 'Name', hint: "Name", controller: nameField),
              16.verticalSpace,

              PhoneNumberField(
                title: "Enter Mobile No.",
                controller: phoneController,
                initialCountryCode: "+91",
              ),

              16.verticalSpace,
              Row(
                children: [
                  SizedBox(
                    height: 16.h,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(4.r),
                      ),
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                      value: isSelected,
                      onChanged: (v) {
                        setState(() {
                          isSelected = v!;
                        });
                      },
                    ),
                  ),

                  Text(
                    "I agree to the ",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  InkWell(
                    onTap: () {
                      router.pushNamed(Routes.privacyPolicy.name);
                    },
                    child: Text(
                      "Terms & Privacy Policy",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              24.verticalSpace,
              PrimaryButton(
                text: "Sign Up",
                onPressed: () {
                  final number = "$selectedCode${phoneController.text}";
                  log(number);

                  router.goNamed(
                    Routes.otp.name,
                    pathParameters: {"number": number, "prev": "signup"},
                  );
                },
              ),

              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? "),
                  GestureDetector(
                    onTap: () => router.goNamed(Routes.signin.name),
                    child: Text(
                      "Sign In",
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
    );
  }
}
