import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy notifications for now
    final notifications = [
      {
        "title": "New Match Found!",
        "body": "You and Anjali Pawar are 80% compatible.",
        "time": "5 min ago",
      },
      {
        "title": "Request Accepted",
        "body": "John Doe has accepted your request.",
        "time": "20 min ago",
      },
      {
        "title": "New Message",
        "body": "You have a new message from Riya.",
        "time": "1 hr ago",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontFamily: Typo.bold,
            fontSize: 22.sp,
            color: AppColors.headingblack,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => 12.verticalSpace,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon / Avatar
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.pinkAccent,
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
                16.horizontalSpace,

                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif["title"]!,
                        style: TextStyle(
                          fontFamily: Typo.semiBold,
                          fontSize: 16.sp,
                          color: AppColors.headingblack,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        notif["body"]!,
                        style: TextStyle(
                          fontFamily: Typo.medium,
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        notif["time"]!,
                        style: TextStyle(
                          fontFamily: Typo.medium,
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
