import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Chats",
          style: TextStyle(
            color: AppColors.headingblack,
            fontFamily: Typo.bold,
            fontSize: 24.sp,
          ),
        ),

        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatTile(
              ontap: () {
                router.goNamed(Routes.chat.name);
              },
              count: "3",
              img:
                  "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg",
              message: "Haha oh man 🤣🤣🤣",
              name: "John Doe",
              time: "20:00",
            ),
            ChatTile(
              count: "9+",
              img:
                  "https://static.wikia.nocookie.net/przestepcy/images/a/a9/Iosef_Tarasov.jpg/revision/latest/thumbnail/width/360/height/450?cb=20230411203930",
              message: "I killed the dog",
              name: "Iosef Tarasov",
              time: "20:00",
            ),
            ChatTile(
              count: "4",
              img:
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLJh47O0sASNk_wdv4a75wiNyewENK7FzD2A&s",
              message: "Cant find my pencil ✏️",
              name: "Bowery King",
              time: "20:00",
            ),
            ChatTile(
              count: "6",
              img:
                  "https://deadline.com/wp-content/uploads/2023/03/Keanu-Reeves-john-wick-4.jpg",
              message: "Have you seen my dog? 🐕",
              name: "John Wick",
              time: "20:00",
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  String? img;
  String? name;
  String? message;
  String? time;
  String? count;
  VoidCallback? ontap;
  ChatTile({
    super.key,
    this.ontap,
    this.count,
    this.img,
    this.message,
    this.name,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: 30.r,
                backgroundImage: CachedNetworkImageProvider(img!),
              ),
              20.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                      color: AppColors.black,
                      fontFamily: Typo.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    message!,
                    style: TextStyle(
                      color: AppColors.black,
                      fontFamily: Typo.medium,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 12.r,
                child: Text(
                  count!,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Typo.semiBold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              10.verticalSpace,

              Text(
                time!,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: Typo.medium,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ).marginVertical(10.r).paddingHorizontal(24.w),
    );
  }
}
