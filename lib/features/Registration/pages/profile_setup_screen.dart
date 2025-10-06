import 'dart:developer';
import 'dart:io';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/saveNextButton.dart';
import 'package:MilanMandap/core/const/snack_bar.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/app_dropdown.dart';
import 'package:MilanMandap/core/sharedWidgets/apptextfield.dart';
import 'package:MilanMandap/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:MilanMandap/features/Registration/Bloc/profile_setup_bloc/profile_setup_event.dart';
import 'package:MilanMandap/features/Registration/Bloc/profile_setup_bloc/profile_setup_state.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';
import 'package:MilanMandap/features/master_apis/models/education_model.dart';
import 'package:MilanMandap/features/master_apis/models/profession_model.dart';
import 'package:MilanMandap/features/master_apis/models/salary_model.dart';
import 'package:MilanMandap/features/master_apis/models/profile_setup_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileSetupScreen extends StatefulWidget {
  ProfileSetupScreen({super.key, required this.type, required this.age});
  String type;
  String age;
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final ProfileSetupBloc bloc;

  final TextEditingController bioController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController permanentLocationController =
      TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final TextEditingController nativeLocationController =
      TextEditingController();

  SalaryModel? selectedSalaryRange;
  ProfessionModel? selectedProfession;
  EducationModel? selectedEducation;
  GlobalKey<FormState> formKey = GlobalKey();

  ProfileSetupModel? _profileSetup;

  @override
  void initState() {
    log(widget.age);
    ageController.text = widget.age;

    super.initState();
    bloc = ProfileSetupBloc();

    // Fetch master data
    context.read<MasterBloc>().add(GetEducationEvent());
    context.read<MasterBloc>().add(GetProfessionEvent());
    context.read<MasterBloc>().add(GetSalaryEvent());
    context.read<MasterBloc>().add(GetProfileSetupEvent());
  }

  @override
  void dispose() {
    bloc.close();
    bioController.dispose();
    ageController.dispose();
    heightController.dispose();
    permanentLocationController.dispose();
    workLocationController.dispose();
    nativeLocationController.dispose();
    super.dispose();
  }

  /// Prefill form from API
  void _prefill(ProfileSetupModel profile) {
    setState(() {
      bioController.text = profile.bio ?? "";
      ageController.text = (profile.age?.toString()) ?? widget.age;
      heightController.text = profile.height?.toString() ?? "";
      permanentLocationController.text = profile.permanentLocation ?? "";
      workLocationController.text = profile.workLocation ?? "";

      selectedEducation = profile.education != null
          ? EducationModel(
              id: profile.education,
              education: profile.educationName,
            )
          : null;

      selectedProfession = profile.profession != null
          ? ProfessionModel(
              id: profile.profession,
              profession: profile.professionName,
            )
          : null;

      selectedSalaryRange = profile.salary != null
          ? SalaryModel(id: profile.salary, salaryRange: profile.salaryName)
          : null;
    });
  }

  /// Pick multiple images and crop (Square only)
  Future<void> _pickAndCropImages() async {
    final ImagePicker picker = ImagePicker();

    // Calculate remaining slots
    int remaining = 5;
    final state = bloc.state;
    if (state is PickImageLoadedState) remaining -= state.images.length;
    if (remaining <= 0) return;

    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) return;

    List<XFile> croppedImages = [];
    for (var file in pickedFiles.take(remaining)) {
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true, // Lock square on Android
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true, // Lock square on iOS
          ),
        ],
      );

      if (cropped != null) croppedImages.add(XFile(cropped.path));
    }

    bloc.add(PickCroppedImagesEvent(images: croppedImages));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: widget.type == "edit" ? false : true,
          title: Text(
            "Profile Setup",
            style: TextStyle(fontSize: 24.sp, fontFamily: Typo.bold),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<MasterBloc, MasterState>(
              listener: (context, state) {
                if (state is GetProfileSetupLoadedState) {
                  _profileSetup = state.profileSetup;
                  _prefill(state.profileSetup);
                }
              },
            ),
          ],
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Images Section
                    Text(
                      "Upload Photos",
                      style: TextStyle(fontSize: 16.sp, fontFamily: Typo.bold),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
                      buildWhen: (prev, curr) => curr is PickImageLoadedState,
                      builder: (context, state) {
                        List<XFile> pickedImages = state is PickImageLoadedState
                            ? state.images
                            : [];

                        final remaining = 5 - pickedImages.length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Images Selected: ${pickedImages.length} / 5",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: pickedImages.length < 5
                                    ? Colors.red
                                    : Colors.green,
                                fontFamily: Typo.medium,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (remaining > 0)
                                  GestureDetector(
                                    onTap: _pickAndCropImages,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primary,
                                        ),
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.primary,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SizedBox(
                                    height: 90,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: pickedImages.length,
                                      itemBuilder: (context, index) {
                                        final img = pickedImages[index];
                                        return Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                final CroppedFile?
                                                cropped = await ImageCropper()
                                                    .cropImage(
                                                      sourcePath: img.path,
                                                      uiSettings: [
                                                        AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Crop Image',
                                                          toolbarColor:
                                                              AppColors.primary,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          lockAspectRatio: true,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .square,
                                                        ),
                                                        IOSUiSettings(
                                                          title: 'Crop Image',
                                                          aspectRatioLockEnabled:
                                                              true,
                                                          aspectRatioPickerButtonHidden:
                                                              true,
                                                        ),
                                                      ],
                                                    );
                                                if (cropped != null) {
                                                  final newImages =
                                                      List<XFile>.from(
                                                        pickedImages,
                                                      );
                                                  newImages[index] = XFile(
                                                    cropped.path,
                                                  );
                                                  bloc.add(
                                                    PickCroppedImagesEvent(
                                                      images: newImages,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                    ),
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: FileImage(
                                                      File(img.path),
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  final newImages =
                                                      List<XFile>.from(
                                                        pickedImages,
                                                      );
                                                  newImages.removeAt(index);
                                                  bloc.add(
                                                    PickCroppedImagesEvent(
                                                      images: newImages,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black54,
                                                      ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    20.verticalSpace,

                    // --- Form Fields ---
                    AppTextField(
                      isRequired: true,
                      title: "About You (Bio)",
                      hint: "Write a short bio about yourself",
                      controller: bioController,
                      onChanged: (val) =>
                          bloc.add(UpdateFieldEvent(field: "bio", value: val)),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      isRequired: true,
                      title: "Age",
                      hint: "Enter your age",
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) =>
                          bloc.add(UpdateFieldEvent(field: "age", value: val)),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      isRequired: true,
                      title: "Height",
                      hint: "Enter your height",
                      controller: heightController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "height", value: val),
                      ),
                    ),
                    16.verticalSpace,

                    // --- Dropdowns ---
                    BlocBuilder<MasterBloc, MasterState>(
                      buildWhen: (prev, curr) =>
                          curr is GetProfessionLoadingState ||
                          curr is GetProfessionLoadedState ||
                          curr is GetProfessionErrorState,
                      builder: (context, state) {
                        if (state is GetProfessionLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetProfessionLoadedState) {
                          return AppDropdown<String>(
                            title: "Profession",
                            isRequired: true,
                            hint: "Select profession",
                            items: state.professions
                                .map((e) => e.profession!)
                                .toList(),
                            value: selectedProfession?.profession,
                            onChanged: (v) {
                              final selected = state.professions.firstWhere(
                                (e) => e.profession == v,
                              );
                              setState(() => selectedProfession = selected);
                            },
                          );
                        } else if (state is GetProfessionErrorState) {
                          return Text("Error: ${state.message}");
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    16.verticalSpace,

                    BlocBuilder<MasterBloc, MasterState>(
                      buildWhen: (prev, curr) =>
                          curr is GetEducationLoadingState ||
                          curr is GetEducationLoadedState ||
                          curr is GetEducationErrorState,
                      builder: (context, state) {
                        if (state is GetEducationLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetEducationLoadedState) {
                          return AppDropdown<String>(
                            title: "Highest Education",
                            isRequired: true,
                            hint: "Select Education",
                            items: state.educations
                                .map((e) => e.education!)
                                .toList(),
                            value: selectedEducation?.education,
                            onChanged: (v) {
                              final selected = state.educations.firstWhere(
                                (e) => e.education == v,
                              );
                              setState(() => selectedEducation = selected);
                            },
                          );
                        } else if (state is GetEducationErrorState) {
                          return Text("Error: ${state.message}");
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    16.verticalSpace,

                    BlocBuilder<MasterBloc, MasterState>(
                      buildWhen: (prev, curr) =>
                          curr is GetSalaryLoadingState ||
                          curr is GetSalaryLoadedState ||
                          curr is GetSalaryErrorState,
                      builder: (context, state) {
                        if (state is GetSalaryLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetSalaryLoadedState) {
                          return AppDropdown<String>(
                            title: "Salary Range",
                            isRequired: true,
                            hint: "Select Salary",
                            items: state.salarys
                                .map((e) => e.salaryRange!)
                                .toList(),
                            value: selectedSalaryRange?.salaryRange,
                            onChanged: (v) {
                              final selected = state.salarys.firstWhere(
                                (e) => e.salaryRange == v,
                              );
                              setState(() => selectedSalaryRange = selected);
                            },
                          );
                        } else if (state is GetSalaryErrorState) {
                          return Text("Error: ${state.message}");
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    16.verticalSpace,

                    AppTextField(
                      lines: 4,
                      isRequired: true,
                      title: "Permanent Location",
                      hint: "Enter your permanent address",
                      controller: permanentLocationController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(
                          field: "permanentLocation",
                          value: val,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    AppTextField(
                      lines: 4,
                      isRequired: true,
                      title: "Work Location",
                      hint: "Enter your work address",
                      controller: workLocationController,
                      onChanged: (val) => bloc.add(
                        UpdateFieldEvent(field: "workLocation", value: val),
                      ),
                    ),
                    16.verticalSpace,

                    BlocConsumer<ProfileSetupBloc, ProfileSetupState>(
                      listener: (context, state) {
                        if (state is ProfileSetupSubmitSuccessState) {
                          snackbar(
                            color: Colors.green,
                            title: "Great",
                            context,
                            message: state.message,
                          );
                          widget.type == "edit"
                              ? null
                              : router.goNamed(
                                  Routes.familyDetails.name,
                                  pathParameters: {"type2": "normal"},
                                );
                          context.read<MasterBloc>().add(GetprofileStatus());
                        } else if (state is ProfileSetupSubmitFailureState) {
                          snackbar(
                            context,
                            title: "Oops",
                            color: Colors.red,
                            message: state.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ProfileSetupSubmitLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SaveandNextButtons(onNext: _submitProfile);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitProfile() {
    if (formKey.currentState!.validate() &&
        selectedEducation != null &&
        selectedProfession != null &&
        selectedSalaryRange != null) {
      bloc.add(
        SubmitProfileEvent(
          bio: bioController.text,
          age: ageController.text,
          height: heightController.text,
          permanentLocation: permanentLocationController.text,
          workLocation: workLocationController.text,
          education: selectedEducation!.id.toString(),
          profession: selectedProfession!.id.toString(),
          salary: selectedSalaryRange!.id.toString(),
        ),
      );
    } else {
      snackbar(context, message: "Please fill all required fields.");
    }
  }
}
