import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicCompablityScreen2 extends StatefulWidget {
  const BasicCompablityScreen2({super.key});

  @override
  State<BasicCompablityScreen2> createState() => _BasicCompablityScreen2State();
}

class _BasicCompablityScreen2State extends State<BasicCompablityScreen2> {
  // selected values
  String? dietPreference;
  String? smokingHabit;
  String? drinkingHabit;
  String? fitnessActivity;
  String? sleepPattern;
  String? petFriendly;
  String? travelPreference;
  String? dailyRoutine;

  Widget buildChipGroup({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16.sp,
            fontFamily: Typo.bold,
          ),
        ),
        12.verticalSpace,
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  onSelected(option);
                });
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.black,
                fontFamily: Typo.medium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            );
          }).toList(),
        ),
        20.verticalSpace,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basic Compatibility Questions",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20.sp,
            fontFamily: Typo.bold,
          ),
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lifestyle Preferences",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 18.sp,
                  fontFamily: Typo.bold,
                ),
              ),
              24.verticalSpace,

              // groups
              buildChipGroup(
                title: "Diet Preference",
                options: ["Veg", "Non-Veg", "Vegan", "Eggetarian"],
                selectedValue: dietPreference,
                onSelected: (val) => dietPreference = val,
              ),
              buildChipGroup(
                title: "Smoking Habit",
                options: ["Never", "Occasionally", "Regularly"],
                selectedValue: smokingHabit,
                onSelected: (val) => smokingHabit = val,
              ),
              buildChipGroup(
                title: "Drinking Habit",
                options: ["Never", "Socially", "Often"],
                selectedValue: drinkingHabit,
                onSelected: (val) => drinkingHabit = val,
              ),
              buildChipGroup(
                title: "Fitness Activity",
                options: ["Not Active", "Occasionally", "Regularly"],
                selectedValue: fitnessActivity,
                onSelected: (val) => fitnessActivity = val,
              ),
              buildChipGroup(
                title: "Sleep Pattern",
                options: ["Early Bird", "Night Owl", "Flexible"],
                selectedValue: sleepPattern,
                onSelected: (val) => sleepPattern = val,
              ),
              buildChipGroup(
                title: "Pet Friendly",
                options: ["Yes", "No", "Maybe"],
                selectedValue: petFriendly,
                onSelected: (val) => petFriendly = val,
              ),
              buildChipGroup(
                title: "Travel Preference",
                options: [
                  "Homebody",
                  "Occasional Traveler",
                  "Travel Enthusiast",
                ],
                selectedValue: travelPreference,
                onSelected: (val) => travelPreference = val,
              ),
              buildChipGroup(
                title: "Daily Routine",
                options: ["Structured", "Flexible", "Spontaneous"],
                selectedValue: dailyRoutine,
                onSelected: (val) => dailyRoutine = val,
              ),

              30.verticalSpace,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    router.goNamed(Routes.homeAnimationScreen.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 14.h,
                    ),
                  ),
                  child: Text(
                    "Save & Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Typo.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
