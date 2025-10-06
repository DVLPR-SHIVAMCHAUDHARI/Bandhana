import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';

class AppMenuDrawer extends StatefulWidget {
  const AppMenuDrawer({super.key});

  @override
  State<AppMenuDrawer> createState() => _AppMenuDrawerState();
}

class _AppMenuDrawerState extends State<AppMenuDrawer> {
  @override
  void initState() {
    super.initState();
    // ✅ Fire only once
    context.read<MasterBloc>().add(GetYourDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 50.w,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              20.verticalSpace,
              _buildMenuItems(context),
              const Divider(),
              _buildSettingsSection(context),
              _buildSupportTile(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(opacity: 0.4, child: _buildWhoViewedCard()),
                  Chip(
                    backgroundColor: AppColors.primaryOpacity,
                    label: Text(
                      "Comming Soon",
                      style: TextStyle(
                        color: Colors.pinkAccent.shade400,
                        fontFamily: Typo.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Drawer Header (Avatar + Name + District)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        10.widthBox,
        Expanded(
          child: BlocBuilder<MasterBloc, MasterState>(
            buildWhen: (prev, curr) =>
                curr is GetYourDetailsLoadingState ||
                curr is GetYourDetailsLoadedState ||
                curr is GetYourDetailsErrorState,
            builder: (context, state) {
              if (state is GetYourDetailsLoadingState) {
                return Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    12.horizontalSpace,
                    const Text("Loading..."),
                  ],
                );
              } else if (state is GetYourDetailsLoadedState) {
                final user = state.yourDetail;

                return Row(
                  children: [
                    ClipOval(
                      child:
                          (user.profileSetup?.profileUrl1 != null &&
                              user.profileSetup!.profileUrl1!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: user.profileSetup!.profileUrl1!,
                              height: 48,
                              width: 48,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircleAvatar(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(child: Icon(Icons.person)),
                            )
                          : const CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.person),
                            ),
                    ),
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.profileDetails?.fullname ?? "No name",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          user.profileDetails?.districtName ?? "No district",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is GetYourDetailsErrorState) {
                return const Text("Failed to load user");
              }

              // fallback from localDb
              final localUser = localDb.getUserData();
              return Row(
                children: [
                  const CircleAvatar(radius: 24, child: Icon(Icons.person)),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localUser?.fullname ?? "Guest User"),
                      const Text("Loading..."),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  /// 🔹 Drawer Menu Items
  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
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
        ListTile(
          leading: const Icon(Icons.notifications_none),
          title: const Text("Notifications"),
          trailing: const Icon(Icons.circle, size: 8, color: Colors.red),
          onTap: () {
            router.goNamed(Routes.notification.name);
          },
        ),
      ],
    );
  }

  /// 🔹 Settings Section
  Widget _buildSettingsSection(BuildContext context) {
    return ExpansionTile(
      title: const Text("Settings"),
      leading: const Icon(Icons.settings_outlined),
      children: [
        ListTile(
          title: const Text("About"),
          onTap: () => router.goNamed(Routes.about.name),
        ),
        ListTile(
          title: const Text("Privacy Policy"),
          onTap: () => router.goNamed(Routes.privacyPolicy.name),
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text("Logout"),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to logout?"),
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
              logger.d("Token after clear: ${token.accessToken}");
              router.goNamed(Routes.signin.name);
            }
          },
        ),
      ],
    );
  }

  /// 🔹 Support Tile
  Widget _buildSupportTile() {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text("Support"),
      onTap: () {},
    );
  }

  /// 🔹 "Who Viewed You" Card
  Widget _buildWhoViewedCard() {
    return Padding(
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
              offset: const Offset(0, 11),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Who Viewed You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }

  /// 🔹 Viewer Row
  Widget _viewerRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          ),
          8.horizontalSpace,
          Expanded(child: Text(name)),
          if (time.isNotEmpty)
            Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
