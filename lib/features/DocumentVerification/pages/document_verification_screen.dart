import 'dart:io';
import 'package:bandhana/features/DocumentVerification/bloc/upload_bloc.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_event.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({super.key});

  @override
  State<DocumentVerificationScreen> createState() =>
      _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState
    extends State<DocumentVerificationScreen> {
  String? idType;
  String? casteType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadBloc(),
      child: Scaffold(
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
        body: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.verticalSpace,

                    /// Aadhaar / PAN Dropdown
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
                        context: context,
                        docType: idType!,
                        title: "$idType Upload",
                        subtitle: "Upload your $idType card",
                        icon: Urls.icAdhar,
                        file: state.pickedFiles[idType],
                      ),
                      25.verticalSpace,
                    ],

                    /// Caste / Birth Certificate Dropdown
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
                        context: context,
                        docType: casteType!,
                        title: casteType!,
                        subtitle: "Upload your $casteType",
                        icon: Urls.icAdhar,
                        file: state.pickedFiles[casteType],
                      ),
                      25.verticalSpace,
                    ],

                    /// Live Selfie
                    documentVerificationTile(
                      context: context,
                      docType: "Live Selfie",
                      title: "Live Selfie",
                      subtitle: "Take a live selfie for verification",
                      icon: Urls.icAdhar,
                      file: state.pickedFiles["Live Selfie"],
                    ),
                    25.verticalSpace,

                    /// Selfie with ID
                    documentVerificationTile(
                      context: context,
                      docType: "Selfie with ID",
                      title: "Selfie with ID",
                      subtitle: "Take a selfie holding your ID",
                      icon: Urls.icAdhar,
                      file: state.pickedFiles["Selfie with ID"],
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
            );
          },
        ),
      ),
    );
  }

  Widget documentVerificationTile({
    required BuildContext context,
    required String docType,
    required String title,
    required String subtitle,
    required String icon,
    File? file,
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
                  file != null
                      ? "Picked: ${file.path.split('/').last}"
                      : subtitle,
                  style: TextStyle(fontFamily: Typo.regular, fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            context.read<UploadBloc>().add(PickFileEvent(docType));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 5.h),
          ),
          child: Text(
            file != null ? "Change" : "Upload",
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
