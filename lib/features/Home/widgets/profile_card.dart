import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, this.image});
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      height: 500.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: CachedNetworkImageProvider("$image"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7), // dark overlay bottom
            ],
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top right fav icon
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_outline, color: Colors.black),
                ),
              ),
            ),

            const Spacer(),

            // Pro user + Match
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
                  child: const Text(
                    "Pro User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Text(
                  "70% Match",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            10.verticalSpace,

            // Name + Age
            Text(
              "Ananya Pandey, 35",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            5.verticalSpace,

            // Occupation + Location
            Text(
              "Fashion Designer · Nashik",
              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
            ),

            12.verticalSpace,

            // Tags
            Wrap(
              spacing: 8.w,

              children: [
                _buildTag("#Early bird"),
                _buildTag("#Fitness enthusiast"),
                _buildTag("#Non-smoker"),
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
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                    ),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: Typo.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                10.widthBox,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      router.goNamed(Routes.profileDetail.name);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradient,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 14.h,
                      ),
                      child: Text(
                        "View Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: Typo.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
