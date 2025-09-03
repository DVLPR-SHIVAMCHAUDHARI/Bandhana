import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_bloc.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_event.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget documentVerificationTile({
  required BuildContext context,
  required String docType,
  required String title,
  required String subtitle,
  required String icon,
}) {
  return BlocBuilder<UploadBloc, UploadState>(
    buildWhen: (previous, current) =>
        previous.pickedFiles[docType] != current.pickedFiles[docType],
    builder: (context, state) {
      final file = state.pickedFiles[docType];

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
                child: file != null && _isImage(file.path)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.file(file, fit: BoxFit.cover),
                      )
                    : SvgPicture.asset(icon, height: 24.h, width: 24.w),
              ),
              16.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: Typo.semiBold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    file != null ? "Picked file" : subtitle,
                    style: TextStyle(fontFamily: Typo.regular, fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => _showPickerOptions(context, docType),
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
    },
  );
}

bool _isImage(String path) {
  final ext = path.toLowerCase();
  return ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png');
}

void _showPickerOptions(BuildContext context, String docType) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                context.read<UploadBloc>().add(UploadFromCamera(docType));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                context.read<UploadBloc>().add(UploadFromGallery(docType));
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text("Pick File (PDF/DOC/Image)"),
              onTap: () {
                Navigator.pop(context);
                context.read<UploadBloc>().add(UploadFromFile(docType));
              },
            ),
          ],
        ),
      );
    },
  );
}
