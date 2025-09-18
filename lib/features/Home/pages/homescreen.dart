import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/asset_urls.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/typography.dart';
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
    // fire both APIs on home load
    context.read<MasterBloc>().add(GetProfileDetailsEvent());
    context.read<MasterBloc>().add(GetProfileSetupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                _buildBanner(),
                10.verticalSpace,
                _buildTitle(),
                25.verticalSpace,
                _buildMatchesList(),
              ],
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
              IconButton.filled(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                ),
                color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.menu),
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
          return CircleAvatar(
            radius: 21,
            backgroundImage: state.profileSetup.profileUrl1 != null
                ? CachedNetworkImageProvider(state.profileSetup.profileUrl1!)
                : null,
            child: state.profileSetup.profileUrl1 == null
                ? const Icon(Icons.person)
                : null,
          );
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
                state.profileDetail.district ?? "No district",
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

  /// 🔹 Matches List (temporary hardcoded)
  Widget _buildMatchesList() {
    return Column(
      children: const [
        ProfileCard(
          image:
              "https://akm-img-a-in.tosshub.com/indiatoday/images/story/202411/ananya-panday-wears-a-rohit-bal-outfit-to-a-wedding-072542900-1x1.jpg",
        ),
        ProfileCard(
          image:
              "https://static.toiimg.com/thumb/119251396/119251396.jpg?height=746&width=420",
        ),
        ProfileCard(
          image:
              "https://i.pinimg.com/736x/6f/62/2c/6f622c7f81a2ccdcae10897d5d981e53.jpg",
        ),
        ProfileCard(
          image:
              "https://i.pinimg.com/736x/4d/b7/66/4db7663736311173d3b3ae36fc4807f9.jpg",
        ),
      ],
    );
  }
}
