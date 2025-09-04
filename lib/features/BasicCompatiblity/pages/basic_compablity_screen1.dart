import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/BasicCompatiblity/repositories/basic_compatiblity_repository.dart';
import 'package:bandhana/features/BasicCompatiblity/widgets/lifestyle_pref_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicCompablityScreen1 extends StatefulWidget {
  const BasicCompablityScreen1({super.key});

  @override
  State<BasicCompablityScreen1> createState() => _BasicCompablityScreen1State();
}

class _BasicCompablityScreen1State extends State<BasicCompablityScreen1> {
  RangeValues selectedAgeRange = const RangeValues(21, 30);

  RangeValues selectedHeightRange = const RangeValues(60, 72);
  String? selectedSalaryRange;

  String? selectedReligion;
  String? selectedCast;
  String? selectedEducationLevel;
  String? selectedProfession;
  String? selectedJobRole;

  List<String> selectedLifestyle = [];
  List<String> selectedWorkLocation = [];
  List<String> selectedNativeLocation = [];

  String inchesToFeet(int inches) {
    final feet = inches ~/ 12;
    final inch = inches % 12;
    return "$feet'$inch\"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basic Compatibility Questions",
          style: TextStyle(
            color: AppColors.headingblack,
            fontSize: 24.sp,
            fontFamily: Typo.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.verticalSpace,
                Text(
                  "Partner expectations",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 18.sp,
                    fontFamily: Typo.bold,
                  ),
                ),

                25.verticalSpace,

                // 🔹 Age Range
                Text(
                  "Age Range: ${selectedAgeRange.start.toInt()} - ${selectedAgeRange.end.toInt()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RangeSlider(
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primaryOpacity,
                  values: selectedAgeRange,
                  min: 18,
                  max: 100,
                  divisions: 82,
                  labels: RangeLabels(
                    selectedAgeRange.start.toInt().toString(),
                    selectedAgeRange.end.toInt().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      selectedAgeRange = values;
                    });
                  },
                ),

                30.verticalSpace,

                Text(
                  "Height Range: ${inchesToFeet(selectedHeightRange.start.toInt())} - ${inchesToFeet(selectedHeightRange.end.toInt())}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RangeSlider(
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primaryOpacity,
                  values: selectedHeightRange,
                  min: 48, // 4'0"
                  max: 96, // 8'0"
                  divisions: 36,
                  labels: RangeLabels(
                    inchesToFeet(selectedHeightRange.start.toInt()),
                    inchesToFeet(selectedHeightRange.end.toInt()),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      selectedHeightRange = values;
                    });
                  },
                ),
                25.verticalSpace,

                AppDropdown(
                  title: 'Religion',
                  hint: 'select',
                  items: religionCast['religions']!,
                  value: selectedReligion,
                  onChanged: (val) {
                    setState(() {
                      selectedReligion = val.toString();
                      selectedCast =
                          null; // 🔹 Reset caste when religion changes
                    });
                  },
                ),
                25.verticalSpace,

                AppDropdown(
                  title: 'Cast',
                  hint: 'select',
                  items: (selectedReligion != null)
                      ? religionCast[selectedReligion]!
                      : [],
                  value: selectedCast,
                  onChanged: (val) {
                    setState(() {
                      selectedCast = val.toString();
                    });
                  },
                ),
                25.verticalSpace,
                AppDropdown(
                  title: 'Education Level',
                  hint: 'select',
                  items: education_levels,
                  value: selectedEducationLevel,
                  onChanged: (val) {
                    setState(() {
                      selectedEducationLevel = val.toString();
                    });
                  },
                ),
                25.verticalSpace,
                AppDropdown(
                  title: 'Profession',
                  hint: 'select',
                  items: professions['professions']!,
                  value: selectedProfession,
                  onChanged: (val) {
                    setState(() {
                      selectedProfession = val.toString();
                      selectedJobRole =
                          null; // 🔹 Reset caste when religion changes
                    });
                  },
                ),
                25.verticalSpace,
                AppDropdown(
                  title: 'Job role',
                  hint: 'select',
                  items: (selectedProfession != null)
                      ? professions[selectedProfession]!
                      : [], // ✅ safe fallback
                  value: selectedJobRole,
                  onChanged: (val) {
                    setState(() {
                      selectedJobRole = val.toString();
                    });
                  },
                ),

                25.verticalSpace,

                AppDropdown(
                  title: 'Annual Salary',
                  hint: 'Select Salary Range',
                  items: annualSalaryRanges,
                  value: selectedSalaryRange,
                  onChanged: (val) {
                    setState(() {
                      selectedSalaryRange = val.toString();
                    });
                  },
                ),

                25.verticalSpace,
                Text(
                  "Work Location Preferences",
                  style: TextStyle(
                    fontFamily: Typo.bold,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ),
                19.verticalSpace,
                MultiSelectDropdown(
                  items: maharashtraDistricts,
                  selectedItems: selectedWorkLocation,
                  hintText: "Select Work Location",
                  onChanged: (values) {
                    setState(() {
                      selectedWorkLocation = values;
                    });
                  },
                ),

                25.verticalSpace,
                Text(
                  "Native Location Preferences",
                  style: TextStyle(
                    fontFamily: Typo.bold,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ),
                19.verticalSpace,
                MultiSelectDropdown(
                  items: maharashtraDistricts,
                  selectedItems: selectedNativeLocation,
                  hintText: "Select Native Location",
                  onChanged: (values) {
                    setState(() {
                      selectedNativeLocation = values;
                    });
                  },
                ),

                25.verticalSpace,
                AppTextField(
                  title: "Other Expectation",
                  hint: "Write something",
                  lines: 4,
                ),
                25.verticalSpace,

                SaveandNextButtons(
                  onNext: () {
                    // Example usage
                    debugPrint(
                      "Selected Age: ${selectedAgeRange.start}-${selectedAgeRange.end}",
                    );
                    debugPrint(
                      "Selected Height: ${inchesToFeet(selectedHeightRange.start.toInt())} - ${inchesToFeet(selectedHeightRange.end.toInt())}",
                    );

                    router.pushNamed(Routes.compatablity2.name);
                  },
                ),
                10.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
