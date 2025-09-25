import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Requests",
          style: TextStyle(
            color: AppColors.headingblack,
            fontFamily: Typo.bold,
            fontSize: 24.sp,
          ),
        ),

        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RequestCard(),
              RequestCard(),
              RequestCard(),
              RequestCard(),
              200.verticalSpace,
            ],
          ).paddingHorizontal(24.w),
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  const RequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      clipBehavior: Clip.none,
      width: double.infinity,
      height: 220.h,

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Urls.igSplashBackground),
          fit: BoxFit.fitWidth,
          opacity: 0.05,
        ),
        borderRadius: BorderRadius.circular(30.r),
        gradient: AppColors.splashGradient,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "☆ Pro User",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.medium,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Text(
                    "70% Match",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                "30 min ago",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: Typo.medium,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.verticalSpace,

          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: CachedNetworkImageProvider(
                  "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg",
                ),
              ),
              20.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe, 36",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.bold,
                      fontSize: 18.sp,
                    ),
                  ),

                  Text(
                    "Fashion Designer",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.medium,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    "#Creative • #CoffeeLover • #TravelsOften",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.medium,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Reject",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.semiBold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              10.widthBox,
              Expanded(
                child: InkWell(
                  onTap: () {
                    router.goNamed(
                      Routes.profileDetail.name,

                      pathParameters: {
                        "match": "90",
                        "mode": ProfileMode.incomingRequest.name,
                        "id": 1.toString(),
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 12.h,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      "View & Accept",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.semiBold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
