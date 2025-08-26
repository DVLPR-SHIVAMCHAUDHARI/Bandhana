import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/saveNextButton.dart';
import 'package:bandhana/core/sharedWidgets/app_dropdown.dart';
import 'package:bandhana/core/sharedWidgets/apptextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Dropdown values
  String? gender;
  String? nationality;
  String? state;
  String? district;
  String? birthPlace;
  String? zodiac;
  String? religion;
  String? maritalStatus;

  // Date & Time
  DateTime? dob;
  TimeOfDay? birthTime;

  // Hobbies
  final List<String> hobbies = [
    "📖 Reading",
    "🎶 Music",
    "✈️ Traveling",
    "⚽️ Sports",
    "🧑🏻‍🍳 Cooking",
    "🎨 Painting",
    "📸 Photography",
    "🎮 Gaming",
    "🪴 Gardening",
    "📝 Writing",
  ];
  final Set<String> selectedHobbies = {};

  Widget _buildDatePicker(String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => dob = picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryOpacity,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.8),
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : hint,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildTimePicker(String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) setState(() => birthTime = picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primaryOpacity,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.2),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.8),
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: const Icon(Icons.access_time),
            ),
            child: Text(
              birthTime != null ? birthTime!.format(context) : hint,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildHobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Your Hobbies",
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 16.sp,
            color: const Color(0xff383838),
          ),
        ),
        10.verticalSpace,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: hobbies.map((hobby) {
            final isSelected = selectedHobbies.contains(hobby);
            return ChoiceChip(
              label: Text(hobby),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedHobbies.add(hobby);
                  } else {
                    selectedHobbies.remove(hobby);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.black,
                fontFamily: Typo.medium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
        16.verticalSpace,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                AppTextField(
                  title: "Full Name",
                  hint: "Full Name",
                  controller: fullNameController,
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "Gender",
                  hint: "Gender",
                  items: ["Male", "Female", "Other"],
                  value: gender,
                  onChanged: (v) => setState(() => gender = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "Nationality",
                  hint: "Nationality",
                  items: ["India", "Other"],
                  value: nationality,
                  onChanged: (v) => setState(() => nationality = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "State",
                  hint: "Maharashtra",
                  items: ["Maharashtra", "Gujarat"],
                  value: state,
                  onChanged: (v) => setState(() => state = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "District",
                  hint: "District",
                  items: ["Nashik", "Pune"],
                  value: district,
                  onChanged: (v) => setState(() => district = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "Birth Place",
                  hint: "Birth Place",
                  items: ["Nashik", "Mumbai"],
                  value: birthPlace,
                  onChanged: (v) => setState(() => birthPlace = v),
                ),
                16.verticalSpace,

                _buildDatePicker("Date of Birth", "01/07/2025"),
                16.verticalSpace,

                _buildTimePicker("Birth time", "01:10 pm"),
                16.verticalSpace,

                AppDropdown(
                  title: "Zodiac",
                  hint: "Zodiac",
                  items: ["Aries", "Taurus"],
                  value: zodiac,
                  onChanged: (v) => setState(() => zodiac = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "Religion, Caste",
                  hint: "Religion, Caste",
                  items: ["Hindu", "Muslim"],
                  value: religion,
                  onChanged: (v) => setState(() => religion = v),
                ),
                16.verticalSpace,

                AppDropdown(
                  title: "Marital Status",
                  hint: "Marital Status",
                  items: ["Single", "Married"],
                  value: maritalStatus,
                  onChanged: (v) => setState(() => maritalStatus = v),
                ),
                16.verticalSpace,

                AppTextField(
                  title: "Contact number",
                  hint: "+91",
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                ),
                16.verticalSpace,

                AppTextField(
                  title: "Email (if any)",
                  hint: "Email",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                16.verticalSpace,

                _buildHobbies(),
                16.verticalSpace,

                // Buttons
                SaveandNextButtons(
                  onNext: () {
                    router.goNamed(Routes.profilesetup.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
