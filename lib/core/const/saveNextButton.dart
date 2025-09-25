import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SaveandNextButtons({onNext}) {
  return SizedBox(
    height: 50.h,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
      ),
      child: Text(
        "Save & Continue",
        style: TextStyle(
          color: Colors.white,
          fontFamily: Typo.bold,
          fontSize: 16.sp,
        ),
      ),
    ),
  );
}
