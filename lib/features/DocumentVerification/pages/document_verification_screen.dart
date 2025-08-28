import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
// 👈 import your custom dropdown
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({super.key});

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  String? idType; // Aadhaar or PAN
  String? casteType; // Caste or Birth

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Document Verification",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 24.sp,
            fontFamily: Typo.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.verticalSpace,

              /// Aadhaar / PAN Dropdown using AppDropdown
              AppDropdown<String>(
                title: "Select ID Type",
                hint: "Choose ID",
                items: const ["Aadhaar", "PAN"],
                value: idType,
                onChanged: (val) {
                  setState(() => idType = val);
                },
              ),
              16.verticalSpace,

              if (idType != null) ...[
                AppTextField(
                  title: "$idType Number",
                  hint: "Enter $idType number",
                ),
                16.verticalSpace,
                documentVerificationTile(
                  title: "$idType Upload",
                  subtitle: "Upload your $idType card",
                  icon: Urls.icAdhar,
                ),
                25.verticalSpace,
              ],

              /// Caste / Birth Certificate Dropdown using AppDropdown
              AppDropdown<String>(
                title: "Select Document Type",
                hint: "Choose Document",
                items: const ["Caste Certificate", "Birth Certificate"],
                value: casteType,
                onChanged: (val) {
                  setState(() => casteType = val);
                },
              ),
              16.verticalSpace,

              if (casteType != null) ...[
                if (casteType == "Caste Certificate") ...[
                  AppTextField(
                    title: "Caste Certificate Number",
                    hint: "Enter Certificate Number",
                  ),
                  16.verticalSpace,
                ],
                documentVerificationTile(
                  title: casteType!,
                  subtitle: "Upload your $casteType",
                  icon: Urls.icAdhar,
                ),
                25.verticalSpace,
              ],

              /// Live Selfie
              documentVerificationTile(
                title: "Live Selfie",
                subtitle: "Take a live selfie for verification",
                icon: Urls.icAdhar,
              ),
              25.verticalSpace,

              /// Selfie with ID
              documentVerificationTile(
                title: "Selfie with ID",
                subtitle: "Take a selfie holding your ID",
                icon: Urls.icAdhar,
              ),
              25.verticalSpace,

              SaveandNextButtons(
                onNext: () {
                  router.goNamed(Routes.compatablity1.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget documentVerificationTile({
    required String title,
    required String subtitle,
    required String icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              height: 48.h,
              width: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primaryOpacity,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(icon, height: 24.h, width: 24.w),
            ),
            16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: Typo.semiBold, fontSize: 16.sp),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontFamily: Typo.regular, fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: hook with upload BLoC
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 5.h),
          ),
          child: Text(
            "Upload",
            style: TextStyle(
              color: Colors.white,
              fontFamily: Typo.medium,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
