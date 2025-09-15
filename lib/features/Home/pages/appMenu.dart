import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 50.w,

      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Row(
                children: [
                  10.widthBox,
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: Text("J", style: TextStyle(color: Colors.white)),
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Nashik division Maharastra",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
              20.verticalSpace,

              // menu items
              ListTile(
                leading: const Icon(Icons.grid_view_outlined),
                title: const Text("Home"),
                onTap: () {
                  router.goNamed(Routes.homescreen.name);
                  context.pop();
                },
              ),

              ListTile(
                leading: const Icon(Icons.explore_outlined),
                title: const Text("Discover"),
                onTap: () {
                  router.goNamed(Routes.discover.name);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text("Chats"),
                onTap: () {
                  router.goNamed(Routes.chatList.name);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("My Profile"),
                onTap: () {
                  router.goNamed(Routes.myProfile.name);
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.notifications_none),
                title: const Text("Notifications"),
                trailing: const Icon(Icons.circle, size: 8, color: Colors.red),
                onTap: () {},
              ),

              ExpansionTile(
                title: Text("Settings"),
                leading: const Icon(Icons.settings_outlined),

                children: [
                  ListTile(
                    title: const Text("About"),
                    onTap: () {
                      router.goNamed(Routes.about.name);
                    },
                  ),
                  ListTile(
                    title: const Text("Privacy Policy"),
                    onTap: () {
                      router.goNamed(Routes.privacyPolicy.name);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text("Logout"),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text(
                            "Are you sure you want to logout?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await token.clear();

                        final t = token.accessToken;
                        logger.d("Token after clear: $t"); // should print null

                        router.goNamed(Routes.signin.name);
                      }
                    },
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Support"),
                onTap: () {},
              ),

              // "Who Viewed You" card
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 53.r,
                        offset: Offset(0, 11),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Who Viewed You",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      12.verticalSpace,
                      _viewerRow("Rohan Kulkarni", "2min ago"),
                      _viewerRow("Karan Sharma", ""),
                      _viewerRow("Ankit Bhosale", ""),
                      12.verticalSpace,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94F64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "View All",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewerRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          ), // sample avatar
          8.horizontalSpace,
          Expanded(child: Text(name)),
          if (time.isNotEmpty)
            Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
