import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/sharedWidgets/profile_shimmer.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_bloc.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_event.dart';
import 'package:MilanMandap/features/Discover/bloc/discover_state.dart';
import 'package:MilanMandap/features/Home/widgets/profile_card.dart';

import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:flutter/material.dart';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    context.read<MasterBloc>().add(GetProfileDetailsEvent());
    context.read<MasterBloc>().add(GetProfileSetupEvent());
    context.read<DiscoverBloc>().add(FetchUsersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Discover",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 24.sp,
            fontFamily: Typo.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<MasterBloc>().add(GetProfileDetailsEvent());
            context.read<MasterBloc>().add(GetProfileSetupEvent());
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
                          return ProfileCard(
                            viewProfile: () {
                              router.pushNamed(
                                Routes.profileDetailApproved.name,
                                pathParameters: {
                                  "mode": ProfileMode.viewOther.name,
                                  "id": user.userId.toString(),
                                  "match": user.matchPercentage.toString(),
                                },
                              );
                            },
                            onSkip: () {},
                            isFavorite: user.isFavorite,
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
    );
  }
}
