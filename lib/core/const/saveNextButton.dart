import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SaveandNextButtons({onSave, onNext}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: onSave,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          ),
          child: Text(
            "Save As Draft",
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
        child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
          ),
          child: Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
              fontFamily: Typo.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    ],
  );
}
