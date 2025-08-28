import 'package:bandhana/core/const/numberextension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Row(
              children: [
                5.widthBox,
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.pink,
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
                const Spacer(),
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline),
              title: const Text("Matches"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.explore_outlined),
              title: const Text("Discover"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text("Chats"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("My Profile"),
              onTap: () {},
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.notifications_none),
              title: const Text("Notifications"),
              trailing: const Icon(Icons.circle, size: 8, color: Colors.red),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Support"),
              onTap: () {},
            ),

            const Spacer(),

            // "Who Viewed You" card
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
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
                      child: const Text("View All"),
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
