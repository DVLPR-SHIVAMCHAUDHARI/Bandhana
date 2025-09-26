import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';
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
    await Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isAnimate = true;
      });
    });

    await Future.delayed(const Duration(milliseconds: 1600));

    // Make sure Hive box is initialized
    await LocalDbService.instance.init();

    // Load token from secure storage
    await token.load();

    bool isFirstTime = await LocalDbService.instance.checkUserComesFirstTime();

    if (isFirstTime) {
      router.goNamed(Routes.onboard.name);
      return;
    }

    if (token.accessToken != null && token.accessToken!.isNotEmpty) {
      final user = localDb.getUserData();
      logger.e(user);
      if (user != null) {
        if (user.profileDetails == 0) {
          router.goNamed(
            Routes.register.name,
            pathParameters: {"type": "normal"},
          );
          return;
        } else if (user.profileSetup == 0) {
          router.goNamed(
            Routes.profilesetup.name,
            pathParameters: {"type1": "normal"},
          );
          return;
        } else if (user.familyDetails == 0) {
          router.goNamed(Routes.familyDetails.name);
          return;
        } else if (user.partnerExpectations == 0) {
          router.goNamed(Routes.compatablity1.name);
          return;
        } else if (user.partnerLifeStyle == 0) {
          router.goNamed(Routes.compatablity2.name);
          return;
        } else if (user.documentVerification == 0) {
          router.goNamed(Routes.docVerification.name);
          return;
        }
        router.goNamed(Routes.homescreen.name);
      } else {
        // Token exists but user not in local DB → force logout or go to signin
        router.goNamed(Routes.signin.name);
      }
    } else {
      router.goNamed(Routes.signin.name);
    }
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 1200),
                            opacity: isAnimate ? 1.0 : 0,
                            curve: Curves.easeIn,
                            child: SvgPicture.asset(
                              Urls.icBandhanaNameLogo,
                              color: isAnimate ? Colors.white : Colors.black,
                              height: 66.26.h,
                              width: 226.08.w,
                            ),
                          ),
                          2.widthBox,
                          AnimatedSlide(
                            duration: const Duration(milliseconds: 1200),
                            curve: Curves.easeInOut,
                            offset: isAnimate
                                ? const Offset(0, -0.2)
                                : const Offset(-1.5, 0),
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
