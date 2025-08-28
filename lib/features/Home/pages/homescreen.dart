import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Home/pages/appMenu.dart';
import 'package:bandhana/features/Home/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      endDrawer: const AppMenuDrawer(),

      body: Builder(
        builder: (context) => Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: AppColors.mainGradient2),
              padding: EdgeInsets.only(
                top: 50.h,
                left: 24.w,
                right: 24.w,
                bottom: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 42.h,
                        width: 42.w,
                        child: CircleAvatar(child: Icon(Icons.person)),
                      ),
                      9.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Doe",
                            style: TextStyle(
                              fontFamily: Typo.semiBold,
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            "Nashik division Maharastra",
                            style: TextStyle(
                              fontFamily: Typo.regular,
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications_outlined, color: Colors.white),
                      10.horizontalSpace,
                      IconButton.filled(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        color: Colors.black,
                        onPressed: () {
                          // ✅ open the drawer
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.19,
                        child: Transform.translate(
                          offset: const Offset(0, -1), // shift upward by 1px
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.mainGradient2.createShader(bounds),
                            blendMode: BlendMode.srcIn,
                            child: SvgPicture.asset(
                              Urls.icHomepageIc,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      "Suggested Matches",
                      style: TextStyle(
                        fontFamily: Typo.playfairSemiBold,
                        color: Colors.black,
                        fontSize: 28.sp,
                      ),
                    ),
                    Text(
                      "Handpicked Matches for You 💞",
                      style: TextStyle(
                        fontFamily: Typo.regular,
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
