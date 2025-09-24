import 'package:flutter/material.dart';
import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Discover",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 24.sp,
            fontFamily: Typo.bold,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(children: [25.verticalSpace]),
        ),
      ),
    );
  }
}
