import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Home/pages/appMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget {
  final Widget child;
  Navbar({super.key, required this.child});

  final List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Discover"),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chats"),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: "Requests"),
  ];

  final List<String> routes = [
    "/homescreen",
    "/discover",
    "/chatList",
    "/request",
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int selectedIndex = routes.indexWhere((r) => location.startsWith(r));
    if (selectedIndex == -1) selectedIndex = 0;

    return Scaffold(
      endDrawer: AppMenuDrawer(),
      body: Stack(
        children: [
          child,
          Positioned(
            bottom: 0.h,
            left: 20.w,
            right: 20.w,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 20.w),
                height: 77.h,
                decoration: BoxDecoration(
                  color: AppColors.navbarFill,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(items.length, (index) {
                    final isSelected = selectedIndex == index;
                    return InkWell(
                      borderRadius: BorderRadius.circular(100.r),
                      onTap: () {
                        if (!isSelected) {
                          router.go(routes[index]);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : null,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              IconTheme(
                                data: IconThemeData(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  size: 22.sp,
                                ),
                                child: items[index].icon,
                              ),
                              SizedBox(width: 6.w),
                            ],
                            Text(
                              items[index].label!,
                              style: TextStyle(
                                fontFamily: Typo.regular,
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
