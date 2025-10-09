import 'dart:developer';

import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/asset_urls.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/profile_shimmer.dart';
import 'package:MilanMandap/features/Home/bloc/home_bloc.dart';
import 'package:MilanMandap/features/Home/bloc/home_event.dart';
import 'package:MilanMandap/features/Home/bloc/home_state.dart';
import 'package:MilanMandap/features/Home/widgets/profile_card.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPaymentdone = false;
  @override
  void initState() {
    super.initState();
    // fire APIs once on home load
    context.read<MasterBloc>().add(GetYourDetails());
    context.read<HomeBloc>().add(FetchUsersEvent());
    context.read<MasterBloc>().add(GetprofileStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<MasterBloc>().add(GetYourDetails());
              context.read<HomeBloc>().add(FetchUsersEvent());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: Column(
                children: [
                  _buildBanner(),
                  10.verticalSpace,
                  _buildTitle(),
                  25.verticalSpace,
                  BlocConsumer<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is FetchUserFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to load users")),
                        );
                      }
                    },
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
                            return ProfileCard(
                              viewProfile: () {
                                router.pushNamed(
                                  Routes.profileDetail.name,
                                  pathParameters: {
                                    "mode": ProfileMode.viewOther.name,
                                    "id": user.userId.toString(),
                                    "match": user.matchPercentage.toString(),
                                  },
                                );
                              },
                              onSkip: () {
                                // Skip logic: remove current user from list
                                context.read<HomeBloc>().add(
                                  SkipUserEvent(userId: user.userId.toString()),
                                );
                              },
                              isFavorite: user.isFavorite,
                              id: user.userId.toString(),
                              image: user.profileUrl1,
                              age: user.age?.toString() ?? "-",
                              district: user.district ?? "-",
                              match: "${user.matchPercentage ?? 0}",
                              name: isPaymentdone == true
                                  ? user.fullname!
                                  : "${user.fullname!.split(" ").first} ${user.fullname!.split(" ").last[0]}" ??
                                        "No name", //this is goal
                              profession: user.profession ?? "-",
                              hobbies: user.hobbies!
                                  .map((e) => e.hobbyName)
                                  .toList(),
                            );
                          },
                        );
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
      ],
    );
  }

  /// 🔹 Header (gradient bg, avatar, name, district, icons)
  Widget _buildHeader(BuildContext context) {
    return Container(
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
          GestureDetector(
            onTap: () => router.goNamed(Routes.myProfile.name),
            child: _buildUserHeaderInfo(),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  router.pushNamed(Routes.favorite.name);
                },
                child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              10.horizontalSpace,
              InkWell(
                onTap: () {
                  router.pushNamed(Routes.notification.name);
                },
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
              ),
              10.horizontalSpace,
              Builder(
                builder: (ctx) => IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  color: Colors.black,
                  onPressed: () {
                    Scaffold.maybeOf(ctx)?.openEndDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeaderInfo() {
    return BlocBuilder<MasterBloc, MasterState>(
      buildWhen: (prev, curr) =>
          curr is GetProfileStatusLoadingState ||
          curr is GetProfileStatusLoadedState ||
          curr is GetProfileStatusErrorState,
      builder: (context, state) {
        if (state is GetProfileStatusLoadingState) {
          return Row(
            children: [
              const CircleAvatar(
                radius: 21,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              9.horizontalSpace,
              const Text("Loading...", style: TextStyle(color: Colors.white)),
            ],
          );
        } else if (state is GetProfileStatusLoadedState) {
          final user = state.user;
          isPaymentdone = state.user.paymentDone == 0 ? false : true;
          log(isPaymentdone.toString());

          return Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundImage:
                    (user.fullname != null && user.profileUrl1!.isNotEmpty)
                    ? CachedNetworkImageProvider(user.profileUrl1!)
                    : null,
                child: (user.profileUrl1 == null || user.profileUrl1!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              9.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullname ?? "No name",
                    style: TextStyle(
                      fontFamily: Typo.semiBold,
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    user.district ?? "No district",
                    style: TextStyle(
                      fontFamily: Typo.regular,
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (state is GetProfileStatusErrorState) {
          return const Text(
            "Failed to load profile",
            style: TextStyle(color: Colors.red),
          );
        }

        // fallback
        return Row(
          children: [
            const CircleAvatar(radius: 21, child: Icon(Icons.person)),
            9.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Guest User",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text("Loading...", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBanner() {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.19,
        child: Transform.translate(
          offset: const Offset(0, -1),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.mainGradient2.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: SvgPicture.asset(Urls.icHomepageIc, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
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
      ],
    );
  }
}
