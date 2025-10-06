import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/applogocomplete.dart';
import 'package:MilanMandap/core/sharedWidgets/background_widget.dart';
import 'package:MilanMandap/core/sharedWidgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstWelcomeScreen extends StatelessWidget {
  const FirstWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundWidget(
          top: 52.h,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.verticalSpace,
                Text(
                  "Welcome to the",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 22.sp,
                    letterSpacing: 1,
                    fontFamily: Typo.playfairSemiBold,
                  ),
                ),

                AppLogo(colorr: AppColors.primary),

                Text(
                  textAlign: TextAlign.center,
                  "Discover meaningful relationships built on trust, tradition, and togetherness.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp,
                    fontFamily: Typo.medium,
                  ),
                ),
                20.verticalSpace,
                Text(
                  textAlign: TextAlign.center,
                  "MilanMandap isn't just a matrimony app — it's a journey toward a lifelong bond. Whether you're searching for love, companionship, or a deep-rooted cultural connection, we're here to walk that path with you.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp,
                    fontFamily: Typo.medium,
                  ),
                ),

                160.verticalSpace,

                PrimaryButton(
                  text: "Register Now",
                  onPressed: () {
                    router.goNamed(
                      Routes.register.name,
                      pathParameters: {"type": "normal"},
                    );
                  },
                ),

                16.verticalSpace,

                const Text("Start your journey today 💍"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
