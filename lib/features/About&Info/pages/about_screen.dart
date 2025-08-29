import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => router.goNamed(Routes.homescreen.name),
        ),
        centerTitle: false,
        title: const Text(
          "About",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Trusted Partner in Lifelong Connections Welcome to Bandhna, where meaningful relationships begin. We’re not just a matrimony app—we’re a dedicated platform built to bring together hearts, families, and futures. Our goal is simple yet profound: to help you find a life partner who truly complements your journey. In a world full of fast swipes and fleeting connections, we believe in authentic, lasting relationships. That’s why we’ve created a space where compatibility, values, and genuine intentions come first. Whether you're searching for love, companionship, or a soulmate, we're here to support you at every step.",
                      style: TextStyle(
                        fontFamily: Typo.medium,
                        fontSize: 16.sp,
                      ),
                    ),
                    5.heightBox,
                    Text(
                      "Why Choose Us?",
                      style: TextStyle(
                        fontFamily: Typo.medium,
                        fontSize: 16.sp,
                      ),
                    ),
                    5.heightBox,
                    ...List.generate(4, (index) {
                      return Text(
                        "* Verified Profiles: Every member is carefully screened for authenticity to ensure a safe and respectful community.",
                        style: TextStyle(
                          fontFamily: Typo.medium,
                          fontSize: 16.sp,
                        ),
                      );
                    }),
                    5.heightBox,
                    Text(
                      "Your Trusted Partner in Lifelong Connections Welcome to Bandhna, where meaningful relationships begin. We’re not just a matrimony app—we’re a dedicated platform built to bring together hearts, families, and futures. Our goal is simple yet profound: to help you find a life partner who truly complements your journey. In a world full of fast swipes and fleeting connections, we believe in authentic, lasting relationships. That’s why we’ve created a space where compatibility, values, and genuine intentions come first. Whether you're searching for love, companionship, or a soulmate, we're here to support you at every step.",
                      style: TextStyle(
                        fontFamily: Typo.medium,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ).padding(EdgeInsetsGeometry.all(20.w)),
              ),
            ),
          ).paddingHorizontal(20.w),
        ],
      ),
    );
  }
}
