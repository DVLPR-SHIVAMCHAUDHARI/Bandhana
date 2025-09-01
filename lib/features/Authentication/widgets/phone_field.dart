import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? initialCountryCode;
  final String? title;

  final void Function(String)? onCountryChanged;

  const PhoneNumberField({
    super.key,
    required this.title,
    required this.controller,
    this.initialCountryCode = "+91",
    this.onCountryChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late String _selectedCode;

  final List<String> _countryCodes = [
    "+1", // USA
    "+44", // UK
    "+91", // India
    "+61", // Australia
    "+81", // Japan
  ];

  @override
  void initState() {
    super.initState();
    _selectedCode = widget.initialCountryCode ?? "+91";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title!,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        10.verticalSpace,
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            prefixIconConstraints: BoxConstraints(minWidth: 90.w, minHeight: 0),

            prefixIcon: SizedBox(
              width: 90.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCode,
                      style: TextStyle(
                        fontFamily: Typo.bold,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                      items: _countryCodes.map((code) {
                        return DropdownMenuItem(value: code, child: Text(code));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCode = value);
                          widget.onCountryChanged?.call(value);
                        }
                      },
                    ),
                  ),
                  6.horizontalSpace,
                  Container(
                    width: 1,
                    height: 24.h,
                    color: Colors.grey.shade400,
                  ),
                  6.horizontalSpace,
                ],
              ),
            ),

            counterText: "", // hide maxLength counter
            hintText: "Enter mobile number",
            hintStyle: TextStyle(
              fontFamily: Typo.regular,
              fontSize: 14.sp,
              color: Colors.grey,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
