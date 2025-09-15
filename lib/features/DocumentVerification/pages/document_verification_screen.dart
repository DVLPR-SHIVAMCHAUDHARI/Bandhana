import 'dart:io';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_bloc.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_event.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_state.dart';
import 'package:bandhana/features/DocumentVerification/shared_widget/upload_image_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Controllers for text fields
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController casteNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    idNumberController.dispose();
    casteNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadBloc(),
      child: BlocListener<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadPermissionDenied) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${state.permissionFor} permission denied"),
              ),
            );
          } else if (state is UploadPermissionPermanentlyDenied) {
            _showPermissionDialog(context, state.permissionFor);
          } else if (state is UploadSubmitSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            router.goNamed(Routes.compatablity1.name);
          } else if (state is UploadSubmitFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        25.verticalSpace,

                        /// ID Type Dropdown
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
                            controller: idNumberController,
                            isRequired: true,
                          ),
                          16.verticalSpace,
                          documentVerificationTile(
                            context: context,
                            docType: idType!,
                            title: "$idType Upload",
                            subtitle: "Upload your $idType card",
                            icon: Urls.icAdhar,
                          ),
                          25.verticalSpace,
                        ],

                        /// Caste / Birth Certificate Dropdown
                        AppDropdown<String>(
                          title: "Select Document Type",
                          hint: "Choose Document",
                          items: const [
                            "Caste Certificate",
                            "Birth Certificate",
                          ],
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
                              controller: casteNumberController,
                              isRequired: true,
                            ),
                            16.verticalSpace,
                          ],
                          documentVerificationTile(
                            context: context,
                            docType: casteType!,
                            title: casteType!,
                            subtitle: "Upload your $casteType",
                            icon: Urls.icAdhar,
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
                        ),
                        25.verticalSpace,

                        /// Selfie with ID
                        documentVerificationTile(
                          context: context,
                          docType: "Selfie with ID",
                          title: "Selfie with ID",
                          subtitle: "Take a selfie holding your ID",
                          icon: Urls.icAdhar,
                        ),
                        25.verticalSpace,
                        BlocListener<UploadBloc, UploadState>(
                          listener: (context, state) {
                            if (state is UploadPermissionDenied) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${state.permissionFor} permission denied",
                                  ),
                                ),
                              );
                            } else if (state
                                is UploadPermissionPermanentlyDenied) {
                              _showPermissionDialog(
                                context,
                                state.permissionFor,
                              );
                            } else if (state is UploadSubmitSuccess) {
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );

                              // Navigate to Home Screen
                              router.goNamed(
                                Routes.homescreen.name,
                              ); // Replace with your home route
                            } else if (state is UploadSubmitFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          child: SaveandNextButtons(
                            onNext: () {
                              if (_formKey.currentState!.validate()) {
                                final bloc = context.read<UploadBloc>();
                                final picked = bloc.state.pickedFiles;

                                bloc.add(
                                  SubmitUploadEvent(
                                    aadhaarOrPan: idNumberController.text,
                                    casteCertificate:
                                        casteNumberController.text,
                                    aadhaarOrPanFile: picked[idType!],
                                    liveSelfieFile: picked["Live Selfie"],
                                    casteCertificateFile: picked[casteType!],
                                    selfieWithIdFile: picked["Selfie with ID"],
                                  ),
                                );
                              }
                            },
                            onSave: () {
                              if (_formKey.currentState!.validate()) {
                                final bloc = context.read<UploadBloc>();
                                final picked = bloc.state.pickedFiles;

                                bloc.add(
                                  SubmitUploadEvent(
                                    aadhaarOrPan: idNumberController.text,
                                    casteCertificate:
                                        casteNumberController.text,
                                    aadhaarOrPanFile: picked[idType!],
                                    liveSelfieFile: picked["Live Selfie"],
                                    casteCertificateFile: picked[casteType!],
                                    selfieWithIdFile: picked["Selfie with ID"],
                                  ),
                                );
                              }
                            },
                          ),
                        ),

                        25.verticalSpace,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void _showPermissionDialog(BuildContext context, String permissionName) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Permission Required"),
      content: Text(
        "$permissionName permission is permanently denied.\n\n"
        "Please enable it from settings to continue.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(ctx);
            await openAppSettings();
          },
          child: const Text("Open Settings"),
        ),
      ],
    ),
  );
}
