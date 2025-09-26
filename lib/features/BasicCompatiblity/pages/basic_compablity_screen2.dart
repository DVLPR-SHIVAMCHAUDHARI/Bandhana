import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/snack_bar.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_bloc.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_event.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_state.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();

    // Trigger prefill fetch from MasterBloc
    final bloc = context.read<MasterBloc>();
    bloc.add(GetLifestylePreferences());
  }

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
        child: BlocListener<MasterBloc, MasterState>(
          listener: (context, state) {
            // Prefill logic from MasterBloc
            if (state is GetLifestylePreferenceLoadedState) {
              final details = state.lifestylePreference;
              setState(() {
                dietPreference = details.diet;
                smokingHabit = details.smokingHabit;
                drinkingHabit = details.drinkingHabit;
                fitnessActivity = details.fitnessActivity;
                sleepPattern = details.sleepPattern;
                petFriendly = details.petFriendly;
                travelPreference = details.travelPreferences;
                dailyRoutine = details.dailyRoutine;
              });
            }
          },
          child: BlocListener<UserPreferencesBloc, UserPreferencesState>(
            listener: (context, state) {
              // Navigation on successful submit
              if (state is LifestylePreferencesSuccess) {
                snackbar(
                  context,
                  color: Colors.green,
                  title: "Success",
                  message: state.message,
                );
                router.goNamed(Routes.docVerification.name);
                context.read<MasterBloc>().add(GetprofileStatus());
              } else if (state is LifestylePreferencesFailure) {
                snackbar(context, message: state.message);
              }
            },
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

                  BlocBuilder<UserPreferencesBloc, UserPreferencesState>(
                    builder: (context, state) {
                      if (state is LifestylePreferencesLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (dietPreference != null &&
                                smokingHabit != null &&
                                drinkingHabit != null &&
                                fitnessActivity != null &&
                                sleepPattern != null &&
                                petFriendly != null &&
                                travelPreference != null &&
                                dailyRoutine != null) {
                              final preferences = {
                                "diet": dietPreference!,
                                "smoking_habit": smokingHabit!,
                                "drinking_habit": drinkingHabit!,
                                "fitness_activity": fitnessActivity!,
                                "sleep_pattern": sleepPattern!,
                                "travel_preferences": travelPreference!,
                                "pet_friendly": petFriendly!,
                                "daily_routine": dailyRoutine!,
                              };

                              context.read<UserPreferencesBloc>().add(
                                SubmitLifestylePreferencesEvent(preferences),
                              );
                            } else {
                              snackbar(
                                context,
                                message: "Please select all options.",
                              );
                            }
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
