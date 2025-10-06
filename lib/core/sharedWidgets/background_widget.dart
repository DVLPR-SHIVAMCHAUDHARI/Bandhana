import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MilanMandap/core/const/asset_urls.dart';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final double top;

  const BackgroundWidget({super.key, required this.child, this.top = 232});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Big circular background with overlay
            Positioned(
              top: top.h,
              left: -240.w,
              right: -240,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 900.w,
                    height: 900.w,
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      color: Colors.white.withOpacity(0.92),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(Urls.igSplashBackground),

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: 900.w,
                    height: 900.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,

              // bottom: 0,
              top: 750.h,
              child: SafeArea(
                child: SvgPicture.asset(
                  Urls.icSplashDesignLogo,
                  color: AppColors.primary.withOpacity(0.5),
                  height: 27.26.h,
                  width: 320.08.w,
                ),
              ),
            ),

            // Foreground content
            child,
          ],
        ),
      ),
    );
  }
}

class BackgroundWidgetLinear extends StatelessWidget {
  final Widget child;
  final double top;

  const BackgroundWidgetLinear({
    super.key,
    required this.child,
    this.top = 232,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Big circular background with overlay
            Positioned(
              top: top.h,
              left: -240.w,
              right: -240,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: 900.w,
                    height: 900.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.splashGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 900.w,
                    height: 900.w,
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(Urls.igSplashBackground),
                        opacity: 0.1,

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 800.h,

              // bottom: 0,
              child: SafeArea(
                child: SvgPicture.asset(
                  Urls.icSplashDesignLogo,
                  color: AppColors.primary.withOpacity(0.5),
                  height: 27.26.h,
                  width: 320.08.w,
                ),
              ),
            ),

            // Foreground content
            child,
          ],
        ),
      ),
    );
  }
}
