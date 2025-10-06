import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/asset_urls.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompatibilityDialog extends StatelessWidget {
  const CompatibilityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: AppColors.compatiblityLightGradient,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.verticalSpace,
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compatibility",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ).paddingHorizontal(24.w),

            Divider(),
            10.verticalSpace,
            // Zodiac icons container
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 108.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 90.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.darkGradient,
                        ),
                        child: SvgPicture.asset(Urls.icZodiac1),
                      ),
                      SvgPicture.asset(
                        Urls.icOnboardingLogo,
                        width: 40.w,
                        height: 28.h,
                        color: AppColors.primary,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 90.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.darkGradient,
                        ),
                        child: SvgPicture.asset(Urls.icZodiac2),
                      ),
                    ],
                  ),
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Aries",
                          style: TextStyle(
                            fontFamily: Typo.semiBold,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "(you)",
                          style: TextStyle(
                            fontFamily: Typo.semiBold,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Gemini",
                          style: TextStyle(
                            fontFamily: Typo.semiBold,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          "(match)",
                          style: TextStyle(
                            fontFamily: Typo.semiBold,
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingHorizontal(40.w),

                38.verticalSpace,
                Text(
                  "Compatibility: 70% ",
                  style: TextStyle(
                    fontFamily: Typo.playfairSemiBold,
                    color: Colors.black,
                    fontSize: 20.sp,
                  ),
                ),
                14.verticalSpace,
                Text(
                  "Playful, adventurous, and full of shared curiosity.",
                  style: TextStyle(
                    fontFamily: Typo.semiBold,
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
                20.verticalSpace,

                // Compatibility chips
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: [
                    _compatibilityChip("Friendship – 20%"),
                    _compatibilityChip("Love – 40%"),
                    _compatibilityChip("Family – 60%"),
                    _compatibilityChip("Business – 60%"),
                    _compatibilityChip("Relationship – 40%"),
                  ],
                ),

                38.verticalSpace,
                Text(
                  "Overall:",
                  style: TextStyle(
                    fontFamily: Typo.playfairSemiBold,
                    color: Colors.black,
                    fontSize: 20.sp,
                  ),
                ),
                14.verticalSpace,
                Text(
                  "You share a balanced connection with strong family and business alignment, while love and relationships show room to grow. Friendship is present but may need nurturing.",
                  style: TextStyle(
                    fontFamily: Typo.semiBold,
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                ),
                20.verticalSpace,

                // Show Interest button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),

                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    onPressed: () {
                      router.pushNamed(Routes.messageRequested.name);
                    },
                    child: Text(
                      "Show Interest",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.bold,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ).paddingHorizontal(40.w),
            36.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _compatibilityChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryFC,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
    );
  }
}

// 📌 Usage
void showCompatibilityDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const CompatibilityDialog(),
  );
}
