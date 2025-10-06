import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/asset_urls.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/services/local_db_sevice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
    animate();
  }

  animate() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isAnimate = true;
      });
    });

    await Future.delayed(const Duration(milliseconds: 1600));

    // Initialize Hive/local DB
    await LocalDbService.instance.init();

    // Load token from secure storage
    await token.load();

    bool isFirstTime = await LocalDbService.instance.checkUserComesFirstTime();

    if (isFirstTime) {
      router.goNamed(Routes.onboard.name);
      return;
    }

    final user = localDb.getUserData();

    if (token.accessToken == null ||
        token.accessToken!.isEmpty ||
        user == null) {
      // No token or no user → go to signin
      router.goNamed(Routes.signin.name);
      return;
    }

    // Route user based on their setup status
    if (user.profileDetails == 0) {
      router.goNamed(Routes.register.name, pathParameters: {"type": "normal"});
      return;
    }

    if (user.profileSetup == 0) {
      router.goNamed(
        Routes.profilesetup.name,
        pathParameters: {
          "type1": "normal",
          "age": "0", // must provide
        },
      );

      return;
    }

    if (user.familyDetails == 0) {
      router.goNamed(
        Routes.familyDetails.name,
        pathParameters: {"type2": "normal"},
      );
      return;
    }

    if (user.partnerExpectations == 0) {
      router.goNamed(
        Routes.compatablity1.name,
        pathParameters: {"type2": "normal"},
      );
      return;
    }

    if (user.partnerLifeStyle == 0) {
      router.goNamed(
        Routes.compatablity2.name,
        pathParameters: {"type4": "normal"},
      );
      return;
    }

    if (user.documentVerification == 0) {
      router.goNamed(
        Routes.docVerification.name,
        pathParameters: {"type5": "normal"},
      );
      return;
    }

    // All setup done → go to home
    router.goNamed(Routes.homescreen.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Urls.igSplashBackground),
            fit: BoxFit.cover,
            opacity: isAnimate ? 0.10 : 0,
          ),
          gradient: isAnimate ? AppColors.splashGradient : null,
          color: isAnimate ? null : Colors.white,
        ),
        width: double.infinity,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  300.verticalSpace,
                  Center(
                    child: SizedBox(
                      width: double.infinity.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          30.horizontalSpace,
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1200),
                            opacity: isAnimate ? 1.0 : 0,
                            curve: Curves.easeIn,
                            child: SizedBox(
                              height: 200.26.h,
                              // width: 226.08.w,
                              child: Image.asset(
                                Urls.igMilanMandap,
                                color: isAnimate ? Colors.white : Colors.black,
                              ),
                            ),
                            // child: SvgPicture.asset(
                            //   Urls.icMilanMandapNameLogo,
                            //   // Urls.igMilanMandap,
                            //   color: isAnimate ? Colors.white : Colors.black,
                            //   height: 66.26.h,
                            //   width: 226.08.w,
                            // ),
                          ),
                          2.widthBox,
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOut,
                            offset: isAnimate
                                ? Offset(-1, -0.4)
                                : Offset(-3, -0.4),
                            child: SvgPicture.asset(
                              Urls.icSplashLogo,
                              color: isAnimate ? Colors.white : Colors.black,
                              height: 61.26.h,
                              width: 56.08.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 35.h,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1200),
                  opacity: isAnimate ? 1.0 : 0,
                  child: SvgPicture.asset(
                    Urls.icSplashDesignLogo,
                    color: isAnimate ? Colors.white : Colors.black,
                    height: 27.26.h,
                    width: 320.08.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
