import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const/app_colors.dart';
import '../const/typography.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isRequired;
  final validator;
  final int? lines;
  final Function(String)? onChanged; // ✅ Added
  final length;

  const AppTextField({
    super.key,
    this.validator,
    this.lines,
    required this.title,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.onChanged, // ✅ Added
    this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: isRequired == true
              ? validator ??
                    (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    }
              : null,

          onChanged: onChanged,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: Typo.semiBold,
            color: Colors.black,
          ),
          maxLength: length,
          maxLines: lines ?? 1,
          decoration: InputDecoration(
            maintainHintSize: true,
            hintText: hint,
            filled: true,
            fillColor: AppColors.primaryOpacity,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              gapPadding: BorderSide.strokeAlignCenter,
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: BorderSide.strokeAlignCenter,
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              gapPadding: BorderSide.strokeAlignCenter,
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: BorderSide.strokeAlignCenter,
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
