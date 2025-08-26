import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    animate();
    super.initState();
  }

  bool isAnimate = false;
  animate() async {
    await Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        isAnimate = true;
      });
    });
    await Future.delayed(Duration(milliseconds: 1600), () {
      router.goNamed(Routes.onboard.name);
    });
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 290.w,
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
                duration: Duration(milliseconds: 1200),
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
    );
  }
}
