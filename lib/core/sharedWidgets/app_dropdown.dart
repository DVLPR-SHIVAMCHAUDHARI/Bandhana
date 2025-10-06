import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hint;
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;
  final String title;
  final bool isRequired;

  const AppDropdown({
    required this.title,
    super.key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
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

        // ✅ Updated DropdownButtonFormField2
        DropdownButtonFormField2<T>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            filled: true,
            fillColor: AppColors.primaryOpacity,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.8),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: Typo.semiBold,
              color: Colors.grey[600],
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down),
            iconEnabledColor: Colors.black,
          ),
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: Typo.regular,
            color: Colors.black,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    e.toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: Typo.semiBold,
                      color: AppColors.black,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,

          // ✅ Dropdown appearance configuration
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.white,
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            offset: const Offset(0, 0), // 👈 opens exactly below
          ),

          // ✅ Menu item styling
          menuItemStyleData: MenuItemStyleData(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),

          // ✅ Validator (same as before)
          validator: isRequired
              ? (val) {
                  if (val == null) return "This field is required";
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
