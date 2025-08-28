import 'package:bandhana/features/Home/widgets/profile_card.dart';
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
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              25.verticalSpace,
              ProfileCard(
                image:
                    "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202411/ananya-panday-wears-a-rohit-bal-outfit-to-a-wedding-072542900-1x1.jpg?VersionId=MBteOz.thqKED1uk6qJs5FV9N5R9H.8H",
              ),
              ProfileCard(
                image:
                    "https://static.toiimg.com/thumb/119251396/119251396.jpg?height=746&width=420&resizemode=76&imgsize=1572480",
              ),
              ProfileCard(
                image:
                    "https://i.pinimg.com/736x/6f/62/2c/6f622c7f81a2ccdcae10897d5d981e53.jpg",
              ),
              ProfileCard(
                image:
                    "https://i.pinimg.com/736x/4d/b7/66/4db7663736311173d3b3ae36fc4807f9.jpg",
              ),
              ProfileCard(
                image:
                    "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202411/ananya-panday-wears-a-rohit-bal-outfit-to-a-wedding-072542900-1x1.jpg?VersionId=MBteOz.thqKED1uk6qJs5FV9N5R9H.8H",
              ),
              ProfileCard(
                image:
                    "https://static.toiimg.com/thumb/119251396/119251396.jpg?height=746&width=420&resizemode=76&imgsize=1572480",
              ),
              ProfileCard(
                image:
                    "https://i.pinimg.com/736x/6f/62/2c/6f622c7f81a2ccdcae10897d5d981e53.jpg",
              ),
              ProfileCard(
                image:
                    "https://i.pinimg.com/736x/4d/b7/66/4db7663736311173d3b3ae36fc4807f9.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
