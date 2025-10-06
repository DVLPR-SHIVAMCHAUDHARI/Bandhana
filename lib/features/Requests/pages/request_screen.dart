import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/Home/models/home_user_model.dart';
import 'package:MilanMandap/features/Requests/bloc/request_bloc.dart';
import 'package:MilanMandap/features/Requests/bloc/request_event.dart';
import 'package:MilanMandap/features/Requests/bloc/request_state.dart';
import 'package:MilanMandap/features/Requests/shared_widgets/request_card_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<RequestBloc>().add(GetRecievedRequests());

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final bloc = context.read<RequestBloc>();
      if (_tabController.index == 0 &&
          bloc.state is! RecievedRequestsLoadedState) {
        bloc.add(GetRecievedRequests());
      } else if (_tabController.index == 1 &&
          bloc.state is! SentRequestsLoadedState) {
        bloc.add(GetSentRequests());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildRequestList(List<HomeUserModel> users, String tab) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          "No new requests",
          style: TextStyle(
            color: AppColors.headingblack,
            fontSize: 16.sp,
            fontFamily: Typo.medium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index == users.length) return SizedBox(height: 100.h);
        return RequestCard(user: users[index], tab: tab);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Requests",
          style: TextStyle(
            color: AppColors.headingblack,
            fontFamily: Typo.bold,
            fontSize: 24.sp,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.pinkAccent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pinkAccent,
          tabs: const [
            Tab(text: "Received"),
            Tab(text: "Sent"),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// Received tab
                BlocConsumer<RequestBloc, RequestState>(
                  listener: (context, state) {
                    if (state is RejectRequestSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Request rejected successfully"),
                        ),
                      );
                      context.read<RequestBloc>().add(GetRecievedRequests());
                    } else if (state is RejectRequestErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.error}")),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is RecievedRequestsLoadingState ||
                        state is RejectRequestLoadingState) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            const RequestCardShimmer(),
                      ).paddingHorizontal(24.w);
                    } else if (state is RecievedRequestsLoadedState) {
                      return _buildRequestList(
                        state.users,
                        "received",
                      ).paddingHorizontal(24.w);
                    } else if (state is RecievedRequestsErrorState) {
                      return Center(child: Text(state.error));
                    }
                    return const SizedBox();
                  },
                ),

                /// Sent tab
                BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    if (state is SentRequestsLoadingState) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            const RequestCardShimmer(),
                      ).paddingHorizontal(24.w);
                    } else if (state is SentRequestsLoadedState) {
                      return _buildRequestList(
                        state.users,
                        "sent",
                      ).paddingHorizontal(24.w);
                    } else if (state is SentRequestsErrorState) {
                      return Center(child: Text(state.error));
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final HomeUserModel user;
  final String tab;

  const RequestCard({super.key, required this.user, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: AppColors.splashGradient,
      ),
      child: Column(
        children: [
          /// Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${user.matchPercentage}% Match",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.verticalSpace,

          /// Profile row
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: CachedNetworkImageProvider(
                  user.profileUrl1 ?? "",
                ),
              ),
              20.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.fullname}, ${user.age}",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      user.profession ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.medium,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      user.hobbies
                              ?.map((h) => "#${h.hobbyName}")
                              .take(3)
                              .join(" • ") ??
                          "",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: Typo.medium,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.verticalSpace,

          /// Buttons
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (tab == "received") {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<RequestBloc>().add(
                  RejectRecievedRequest(userId: user.userId!),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              ),
              child: Text(
                "Reject",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: Typo.semiBold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: InkWell(
              onTap: () {
                logger.e(
                  "Tapped user id: ${user.userId}",
                ); // This will now print
                router.goNamed(
                  Routes.profileDetail.name,
                  pathParameters: {
                    "match": (user.matchPercentage ?? 0).toString(),
                    "mode": ProfileMode.incomingRequest.name,
                    "id": user.userId.toString(),
                  },
                  extra: user, // <-- pass the HomeUserModel object
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Text(
                  "View & Accept",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Typo.semiBold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                router.goNamed(
                  Routes.profileDetail.name,
                  pathParameters: {
                    "match": user.matchPercentage.toString(),
                    "mode": ProfileMode.outgoingRequest.name,
                    "id": user.userId.toString(),
                  },
                  extra: user, // <-- pass the HomeUserModel object
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Text(
                  "View Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Typo.semiBold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
