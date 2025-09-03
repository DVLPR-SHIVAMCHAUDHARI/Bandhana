import 'dart:async';
import 'dart:math';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeAnimationScreen extends StatefulWidget {
  const HomeAnimationScreen({super.key});

  @override
  State<HomeAnimationScreen> createState() => _HomeAnimationScreenState();
}

class _HomeAnimationScreenState extends State<HomeAnimationScreen> {
  int selectedIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        selectedIndex = (selectedIndex + 1) % 3;
      });
    });
    Future.delayed((Duration(milliseconds: 1500)), () {
      router.goNamed(Routes.homescreen.name);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // cleanup when screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidgetLinear(
        top: 150.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            230.verticalSpace,

            /// Rotating Ring
            Transform.rotate(
              angle: -pi / 25.50,
              child: SizedBox(
                height: 61.h,
                width: 75.w,
                child: SvgPicture.asset(Urls.icRing, height: 61.h, width: 75.w),
              ),
            ),

            10.verticalSpace,

            /// Title
            Text(
              "Love is a journey.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 30.sp,
                fontFamily: Typo.playfairDisplayItalic,
                color: Colors.white,
              ),
            ),

            20.verticalSpace,

            /// Subtitle
            Text(
              "We’re finding those who walk in rhythm with your values and heart. 💞",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: Typo.medium,
                color: Colors.white,
              ),
            ),

            288.verticalSpace,

            /// Heart Animation (indicator)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: SvgPicture.asset(
                    index == selectedIndex
                        ? Urls.icAnimationHeartWhite
                        : Urls.icAnimationHeart,
                    key: ValueKey(index == selectedIndex),
                  ).marginHorizontal(5),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
