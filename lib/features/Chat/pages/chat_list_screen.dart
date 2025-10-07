import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/profile_shimmer.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_bloc.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_event.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_state.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DiscoverBloc>().add(FetchUsersEvent());
  }

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
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DiscoverBloc>().add(FetchUsersEvent());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            child: Column(
              children: [
                10.verticalSpace,
                25.verticalSpace,
                BlocBuilder<DiscoverBloc, DiscoverState>(
                  builder: (context, state) {
                    if (state is FetchUsersLoadingState) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => ProfileCardShimmer(),
                        itemCount: 10,
                      );
                    } else if (state is FetchUserLoadedState) {
                      final users = state.list;
                      if (users.isEmpty) {
                        return const Center(child: Text("No matches found"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ChatTile(
                            ontap: () {
                              router.goNamed(
                                Routes.chat.name,
                                extra: {
                                  'id': user.userId,
                                  'name': user.fullname,
                                  'image': user.profileUrl1,
                                },
                              );
                            },
                            img: user.profileUrl1,
                            name: user.fullname,
                          );
                        },
                      );
                    } else if (state is FetchUserFailureState) {
                      return const Center(child: Text("Failed to load users"));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                100.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      // SizedBox(height: 1000), /÷/ now works correctly
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
                    message ?? "Hi",
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
                  count ?? "10",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Typo.semiBold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              10.verticalSpace,

              Text(
                time ?? "10",
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
