import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:bandhana/features/Authentication/widgets/phone_field.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyDetailsScreen extends StatefulWidget {
  const FamilyDetailsScreen({super.key});

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  TextEditingController fathersPhoneField = TextEditingController();
  TextEditingController mothersPhoneField = TextEditingController();
  List<String> siblingCount = ["0", "1", "2", "3", "4", "5+"];

  List<String> familyTypes = ["Joint", "Nuclear", "Other"];

  List<String> familyStatus = [
    "Middle Class",
    "Upper Middle Class",
    "Rich",
    "Affluent",
  ];

  List<String> familyValues = ["Traditional", "Moderate", "Liberal"];

  String? selectedFamilyType;
  String? selectedFamilyStatus;
  String? selectedFamilyValues;
  String? selectedBrothers;
  String? selectedSisters;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Family Details",
          style: TextStyle(fontSize: 24.sp, fontFamily: Typo.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,

              // ✅ Form Fields
              AppTextField(
                title: "Father's Name",
                hint: "Father's name",
                // controller: bioController,
                onChanged: (val) {},
              ),
              16.verticalSpace,
              AppTextField(
                title: "Father's Occupation",
                hint: "Occupation",
                // controller: ageController,
                keyboardType: TextInputType.number,
                onChanged: (val) {},
              ),
              16.verticalSpace,
              PhoneNumberField(
                title: "Father's Contact",
                controller: fathersPhoneField,
                initialCountryCode: "+91",
              ),
              16.verticalSpace,
              AppTextField(
                title: "Mother's Name",
                hint: "Mother's name",
                // controller: bioController,
                onChanged: (val) {},
              ),
              16.verticalSpace,
              AppTextField(
                title: "Mother's Occupation",
                hint: "Occupation",
                // controller: ageController,
                keyboardType: TextInputType.number,
                onChanged: (val) {},
              ),

              16.verticalSpace,
              PhoneNumberField(
                title: "Mothers's Contact",
                controller: mothersPhoneField,
                initialCountryCode: "+91",
              ),

              16.verticalSpace,

              AppDropdown<String>(
                title: "Number of Brothers",
                hint: "Select brothers count",
                items: siblingCount,
                value: selectedBrothers,
                onChanged: (value) {
                  selectedBrothers = value;
                },
              ),
              16.verticalSpace,
              AppDropdown<String>(
                title: "Number of Sisters",
                hint: "Select sisters count",
                items: siblingCount,
                value: selectedSisters,
                onChanged: (value) {
                  selectedSisters = value;
                },
              ),
              16.verticalSpace,
              AppDropdown<String>(
                title: "Family Type",
                hint: "Select family type",
                items: familyTypes,
                value: selectedFamilyType,
                onChanged: (value) {
                  selectedFamilyType = value;
                },
              ),
              16.verticalSpace,
              AppDropdown<String>(
                title: "Family Status",
                hint: "Select family status",
                items: familyStatus,
                value: selectedFamilyStatus,
                onChanged: (value) {
                  selectedFamilyStatus = value;
                },
              ),
              16.verticalSpace,
              AppDropdown<String>(
                title: "Family Values",
                hint: "Select family values",
                items: familyValues,
                value: selectedFamilyValues,
                onChanged: (value) {
                  selectedFamilyValues = value;
                },
              ),
              16.verticalSpace,
              AppTextField(
                title: "Maternal Uncle’s (Mama) Name",
                hint: "Enter maternal uncle’s name",
                keyboardType: TextInputType.name,
                onChanged: (val) {
                  // save to state
                },
              ),
              16.verticalSpace,
              AppTextField(
                title: "Maternal Uncle’s Village",
                hint: "Enter maternal uncle’s village",
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  // save to state
                },
              ),
              16.verticalSpace,
              AppTextField(
                title: "Mama’s Kul",
                hint: "Enter mama’s kul",
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  // save to state
                },
              ),
              16.verticalSpace,
              AppTextField(
                lines: 4,
                title: "Relatives / Family References (Surnames)",
                hint: "Enter relatives or family references",
                keyboardType: TextInputType.multiline,
                onChanged: (val) {
                  // save to state
                },
              ),
              30.verticalSpace,

              SaveandNextButtons(
                onNext: () {
                  router.goNamed(Routes.docVerification.name);
                },
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
