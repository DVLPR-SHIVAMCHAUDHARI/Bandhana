import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/const/numberextension.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Requests/bloc/request_bloc.dart';
import 'package:bandhana/features/Requests/bloc/request_event.dart';
import 'package:bandhana/features/Requests/bloc/request_state.dart';
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildRequestList(List<HomeUserModel> users) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index == users.length) {
          return SizedBox(height: 100.h);
        }
        return RequestCard(user: users[index]);
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
                BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    if (state is RecievedRequestsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RecievedRequestsLoadedState) {
                      return _buildRequestList(
                        state.users,
                      ).paddingHorizontal(24.w);
                    } else if (state is RecievedRequestsErrorState) {
                      return Center(child: Text(state.error));
                    }
                    return const SizedBox();
                  },
                ),
                Center(child: Text("TODO: Sent requests list")),
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
  const RequestCard({super.key, required this.user});

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
          // top row
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
              Text(
                "30 min ago", // TODO: replace with real time if available
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: Typo.medium,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          20.verticalSpace,

          // profile row
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundImage: CachedNetworkImageProvider(
                  user.profileUrl1 ?? "",
                ),
              ),
              20.horizontalSpace,
              Column(
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
            ],
          ),
          20.verticalSpace,

          // buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 12.h,
                    ),
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
                    router.goNamed(
                      Routes.profileDetail.name,
                      pathParameters: {
                        "match": user.matchPercentage.toString(),
                        "mode": ProfileMode.incomingRequest.name,
                        "id": user.userId.toString(),
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 12.h,
                    ),
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
          ),
        ],
      ),
    );
  }
}
