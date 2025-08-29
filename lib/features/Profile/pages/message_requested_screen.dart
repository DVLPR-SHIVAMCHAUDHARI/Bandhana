import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MessageRequestedScreen extends StatelessWidget {
  const MessageRequestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.white,
        title: Text(
          "Message Requested",
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 24.sp,
            color: AppColors.headingblack,
          ),
        ),
      ),
      body: SafeArea(
        child: BackgroundWidgetLinear(
          top: 33,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(42.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                185.verticalSpace,

                /// Rotating Ring
                SizedBox(
                  height: 61.h,
                  width: 75.w,
                  child: SvgPicture.asset(
                    Urls.icSplashLogo,
                    height: 61.h,
                    width: 75.w,
                    color: Colors.white,
                  ),
                ),

                10.verticalSpace,

                /// Title
                Text(
                  "Request Sent to Ananya Pandey",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontFamily: Typo.playfairDisplayRegular,
                    color: Colors.white,
                  ),
                ),

                20.verticalSpace,

                /// Subtitle
                Text(
                  "Ananya will be notified about your interest. If she’s interested too, we’ll open the chat for you both!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: Typo.medium,
                    color: Colors.white,
                  ),
                ),

                250.verticalSpace,

                InkWell(
                  onTap: () {
                    router.pushNamed(Routes.homescreen.name);
                  },
                  child: Container(
                    height: 57.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24.r,
                          offset: Offset(4, 8),
                          color: AppColors.primaryOpacity,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primary,
                          size: 15.h,
                        ),
                        7.5.horizontalSpace,
                        Text(
                          textAlign: TextAlign.center,
                          "Back to Matches",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontFamily: Typo.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
