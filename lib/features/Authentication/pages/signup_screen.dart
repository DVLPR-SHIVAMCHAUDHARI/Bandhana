import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';

import 'package:bandhana/core/const/typography.dart';

import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:bandhana/core/sharedWidgets/primary_button.dart';
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
  TextEditingController numberField = TextEditingController();
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
              AppTextField(
                controller: numberField,
                title: "Mobile No.",
                hint: "Mobile No.",
                keyboardType: TextInputType.phone,
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
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: Typo.regular,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: "I agree to the "),
                          TextSpan(
                            text: "Terms",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(text: " & "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              24.verticalSpace,
              PrimaryButton(
                text: "Sign Up",
                onPressed: () {
                  router.goNamed(Routes.otp.name);
                },
              ),

              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/signin"),
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
