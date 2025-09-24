import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/core/sharedWidgets/profile_shimmer.dart';
import 'package:bandhana/features/Home/bloc/home_bloc.dart';
import 'package:bandhana/features/Home/bloc/home_event.dart';
import 'package:bandhana/features/Home/bloc/home_state.dart';
import 'package:bandhana/features/Home/widgets/profile_card.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/master_apis/bloc/master_state.dart';
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
  @override
  void initState() {
    super.initState();
    // fire APIs once on home load
    context.read<MasterBloc>().add(GetProfileDetailsEvent());
    context.read<MasterBloc>().add(GetProfileSetupEvent());
    context.read<HomeBloc>().add(FetchUsersEvent()); // ✅ moved from build
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // Trigger your API calls again
              context.read<MasterBloc>().add(GetProfileDetailsEvent());
              context.read<MasterBloc>().add(GetProfileSetupEvent());
              context.read<HomeBloc>().add(FetchUsersEvent());

              // Optionally wait for a short duration for smooth effect
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ), // ✅ needed for pull-to-refresh
              child: Column(
                children: [
                  _buildBanner(),

                  10.verticalSpace,
                  _buildTitle(),
                  25.verticalSpace,
                  BlocBuilder<HomeBloc, HomeState>(
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
                              id: user.userId.toString(),
                              image: user.profileUrl1,
                              age: user.age?.toString() ?? "-",
                              district: user.district ?? "-",
                              match: "${user.matchPercentage ?? 0}% match",
                              name: user.fullname ?? "Unknown",
                              profession: user.profession ?? "-",
                              hobbies: user.hobbies!
                                  .map((e) => e.hobbyName)
                                  .toList(),
                            );
                          },
                        );
                      } else if (state is FetchUserFailureState) {
                        return const Center(
                          child: Text("Failed to load users"),
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
          Row(
            children: [
              _buildUserAvatar(),
              9.horizontalSpace,
              GestureDetector(
                onTap: () => router.goNamed(Routes.myProfile.name),
                child: _buildUserDetails(),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white),
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

  /// 🔹 User Avatar (from Setup API)
  Widget _buildUserAvatar() {
    return BlocBuilder<MasterBloc, MasterState>(
      buildWhen: (prev, curr) =>
          curr is GetProfileSetupLoadingState ||
          curr is GetProfileSetupLoadedState ||
          curr is GetProfileSetupErrorState,
      builder: (context, state) {
        if (state is GetProfileSetupLoadingState) {
          return _loadingAvatar();
        } else if (state is GetProfileSetupLoadedState) {
          final url = state.profileSetup.profileUrl1;
          if (url != null && url.isNotEmpty) {
            return CircleAvatar(
              radius: 21,
              backgroundImage: CachedNetworkImageProvider(url),
            );
          } else {
            return const CircleAvatar(radius: 21, child: Icon(Icons.person));
          }
        }
        return const CircleAvatar(radius: 21, child: Icon(Icons.person));
      },
    );
  }

  Widget _loadingAvatar() => const SizedBox(
    height: 42,
    width: 42,
    child: CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
  );

  /// 🔹 User Details (from Details API)
  Widget _buildUserDetails() {
    return BlocBuilder<MasterBloc, MasterState>(
      buildWhen: (prev, curr) =>
          curr is GetProfileDetailsLoadingState ||
          curr is GetProfileDetailsLoadedState ||
          curr is GetProfileDetailsErrorState,
      builder: (context, state) {
        if (state is GetProfileDetailsLoadingState) {
          return const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        } else if (state is GetProfileDetailsLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.profileDetail.fullname ?? "No name",
                style: TextStyle(
                  fontFamily: Typo.semiBold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                state.profileDetail.districtName ?? "No district",
                style: TextStyle(
                  fontFamily: Typo.regular,
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ],
          );
        } else if (state is GetProfileDetailsErrorState) {
          return const Text(
            "Failed to load profile",
            style: TextStyle(color: Colors.red),
          );
        }
        // fallback from local db
        final localUser = localDb.getUserData();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localUser?.fullname ?? "Guest User",
              style: TextStyle(
                fontFamily: Typo.semiBold,
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            Text(
              "Loading...",
              style: TextStyle(
                fontFamily: Typo.regular,
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Banner Gradient + SVG
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

  /// 🔹 Title
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
