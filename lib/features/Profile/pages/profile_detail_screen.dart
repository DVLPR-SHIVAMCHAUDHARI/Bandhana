import 'dart:ui';

import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/Home/bloc/home_bloc.dart';
import 'package:MilanMandap/features/Home/bloc/home_event.dart';
import 'package:MilanMandap/features/Home/bloc/home_state.dart';
import 'package:MilanMandap/features/Home/models/home_user_model.dart';

import 'package:MilanMandap/features/Profile/bloc_normal/profile_detail_bloc.dart';
import 'package:MilanMandap/features/Profile/bloc_normal/profile_detail_event.dart';
import 'package:MilanMandap/features/Profile/bloc_normal/profile_detail_state.dart';

import 'package:MilanMandap/features/Profile/widgets/compatibility_check_dialog.dart';
import 'package:MilanMandap/features/Requests/bloc/request_bloc.dart';
import 'package:MilanMandap/features/Requests/bloc/request_event.dart';
import 'package:MilanMandap/features/Requests/bloc/request_state.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart'
    hide ToggleFavoriteEvent;
import 'package:MilanMandap/features/master_apis/bloc/master_state.dart'
    hide ToggleFavoriteSuccess;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileDetailedScreen extends StatefulWidget {
  const ProfileDetailedScreen({
    super.key,
    required this.mode,
    required this.id,
    required this.match,
  });

  final String mode;
  final String id;
  final String match;

  @override
  State<ProfileDetailedScreen> createState() => _ProfileDetailedScreenState();
}

class _ProfileDetailedScreenState extends State<ProfileDetailedScreen> {
  bool isPaymentdone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statusBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()..add(FetchUsersEvent())),
        BlocProvider(create: (_) => RequestBloc()),
        BlocProvider(create: (_) => ProfileDetailBloc()),
        BlocProvider(create: (_) => MasterBloc()..add(GetprofileStatus())),
      ],
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is FetchUsersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FetchUserFailureState) {
              return Center(child: Text(state.message!));
            } else if (state is FetchUserLoadedState) {
              final int? userId = int.tryParse(widget.id);
              HomeUserModel? user;

              // Try using extra if available
              user = GoRouterState.of(context).extra as HomeUserModel?;

              // fallback to HomeBloc list if extra is null
              if (user == null && userId != null) {
                user = state.list.cast<HomeUserModel?>().firstWhere(
                  (u) => u?.userId == userId,
                  orElse: () => null,
                );
              }

              // If user is still null, show error
              if (user == null) {
                return const Center(child: Text("User not found"));
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainImage(context, user),
                    Transform.translate(
                      offset: Offset(0, -40),
                      child: _buildAvatarStack(context, user),
                    ),
                    _buildProfileDetails(user),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: buildBottombar(context),
      ),
    );
  }

  // --- buildBottombar ---
  SafeArea buildBottombar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: widget.mode == 'viewOther'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CompatibilityDialog(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 14.h,
                        ),
                      ),
                      child: Text(
                        "Check Match",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: Typo.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  10.widthBox,
                  Expanded(
                    child: BlocConsumer<ProfileDetailBloc, ProfileDetailState>(
                      listener: (context, state) {
                        if (state is SendRequestLoadedState) {
                          router.goNamed(Routes.messageRequested.name);
                        } else if (state is SendRequestErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SendRequestLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }

                        return BlocBuilder<MasterBloc, MasterState>(
                          builder: (context, state) {
                            bool paid =
                                false; //if this is false then how am i able to trigger this  send request?
                            if (state is GetProfileStatusLoadedState) {
                              paid = state.user.paymentDone != 0;
                            }
                            return InkWell(
                              onTap: () {
                                if (!paid) {
                                  router.pushNamed(Routes.choosePlan.name);
                                } else {
                                  context.read<ProfileDetailBloc>().add(
                                    SendRequestEvent(widget.id),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 24.r,
                                      offset: Offset(4, 8),
                                      color: AppColors.primaryOpacity,
                                    ),
                                  ],
                                  gradient: AppColors.buttonGradient,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 14.h,
                                ),
                                child: Text(
                                  "Show Interest",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Typo.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : widget.mode == "incomingRequest"
            ? Row(
                children: [
                  Expanded(
                    child: BlocConsumer<RequestBloc, RequestState>(
                      listener: (context, state) {
                        if (state is RejectRequestSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Request rejected successfully"),
                            ),
                          );
                          router.goNamed(Routes.request.name);
                        } else if (state is RejectRequestErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${state.error}")),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RejectRequestLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        return OutlinedButton(
                          onPressed: () {
                            context.read<RequestBloc>().add(
                              RejectRecievedRequest(
                                userId: int.parse(widget.id),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 14.h,
                            ),
                          ),
                          child: Text(
                            "Reject",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: Typo.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  10.horizontalSpace,

                  Expanded(
                    child: BlocConsumer<ProfileDetailBloc, ProfileDetailState>(
                      listener: (context, state) {
                        if (state is AcceptRequestLoadedState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Request accepted successfully"),
                            ),
                          );
                          router.goNamed(Routes.chatList.name);
                        } else if (state is AcceptRequestErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${state.message}")),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AcceptRequestLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }
                        return InkWell(
                          onTap: () {
                            context.read<ProfileDetailBloc>().add(
                              AcceptRequestEvent(widget.id),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 24.r,
                                  offset: Offset(4, 8),
                                  color: AppColors.primaryOpacity,
                                ),
                              ],
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 14.h,
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Accept Request",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: Typo.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  }

  // --- _buildMainImage ---
  Widget _buildMainImage(BuildContext context, HomeUserModel user) {
    final List<String?> avatars = [
      user.profileUrl1,
      user.profileUrl2,
      user.profileUrl3,
      user.profileUrl4,
      user.profileUrl5,
    ];

    return BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
      builder: (context, state) {
        String imageUrl;
        int centerIndex = 3;
        bool isFavorite = user.isFavorite == 0 ? false : true ?? false;

        if (state is ProfileDetailLoaded) {
          isFavorite = state.isFavorite;
        } else if (state is ToggleFavoriteSuccess) {
          isFavorite = state.isFavorite;
        } else if (state is SwitchImageState) {
          isFavorite = state.isFavorite;
        }

        if (state is SwitchImageState) {
          imageUrl = state.avatars[centerIndex]['url'];
        } else {
          imageUrl = avatars[centerIndex] ?? '';
        }

        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 550.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(height: 500.h, color: Colors.grey[200]),
              errorWidget: (_, __, ___) =>
                  Container(height: 500.h, color: Colors.grey),
            ),
            Container(
              height: 550.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.mode == ProfileMode.viewOther.name
                              ? router.goNamed(Routes.homescreen.name)
                              : router.goNamed(Routes.request.name);
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<ProfileDetailBloc>().add(
                            ToggleFavoriteEvent(userId: user.userId.toString()),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: isFavorite ? Colors.pink : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  200.verticalSpace,
                  Text(
                    "${isPaymentdone == true ? user.fullname! : "${user.fullname!.split(" ").first} ${user.fullname!.split(" ").last[0]}" ?? "No name"}, ${user.age}",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: Typo.playfairDisplayRegular,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    "${user.profession} · ${user.district}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                  ),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      user.hobbies!.length,
                      (index) =>
                          _buildTag("#${user.hobbies![index].hobbyName}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // --- _buildAvatarStack ---
  Widget _buildAvatarStack(BuildContext context, HomeUserModel user) {
    final List<String?> avatars = [
      user.profileUrl1,
      user.profileUrl2,
      user.profileUrl3,
      user.profileUrl4,
      user.profileUrl5,
    ];

    const int centerIndex = 3;

    return SizedBox(
      height: 100.h,
      child: BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
        builder: (context, state) {
          List<Map<String, dynamic>> avatarPositions = List.generate(
            avatars.length,
            (index) {
              final screenWidth = MediaQuery.sizeOf(context).width;

              double top;
              double? left;
              double? right;
              double size;

              // 🎯 Scale top offsets proportionally
              if (index == centerIndex) {
                top = -0.15 * screenWidth; // about -5% of width
              } else if (index == 1 || index == 2) {
                top = -0.02 * screenWidth; // about -2% of width
              } else {
                top = 0.03 * screenWidth; // about +3% of width
              }

              // 🎯 Scale horizontal positions
              switch (index) {
                case 0:
                  left = 0.0;
                  break;
                case 1:
                  left = screenWidth * 0.15;
                  break;
                case 2:
                  right = screenWidth * 0.15;
                  break;
                case 3:
                  left = screenWidth * 0.32;
                  break;
                case 4:
                  right = 0.0;
                  break;
                default:
                  break;
              }

              // 🎯 Scalable avatar sizes
              size = index == centerIndex
                  ? 0.38 * screenWidth
                  : 0.25 * screenWidth;

              return {
                'index': index,
                'url': avatars[index] ?? '',
                'top': top,
                'left': left,
                'right': right,
                'size': size,
              };
            },
          );

          if (state is SwitchImageState) {
            avatarPositions = state.avatars;
          }

          return Stack(
            clipBehavior: Clip.none,
            children: List.generate(avatarPositions.length, (index) {
              final avatar = avatarPositions[index];
              return Positioned(
                top: avatar['top'],
                left: avatar['left'],
                right: avatar['right'],
                child: GestureDetector(
                  onTap: () {
                    if (index != centerIndex) {
                      context.read<ProfileDetailBloc>().setCurrentUser(user);
                      context.read<ProfileDetailBloc>().add(
                        SwitchImageEvent(index, avatarPositions),
                      );
                    }
                  },
                  child: Container(
                    height: avatar['size'],
                    width: avatar['size'],
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: index == centerIndex
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: avatar['url'],
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // --- _buildProfileDetails ---
  Widget _buildProfileDetails(HomeUserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "${widget.match} % Match With Your Profile",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: Typo.playfairBold,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- ABOUT ----------
                  Text(
                    "About ${user.fullname?.split(' ').first ?? ''}",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: Typo.playfairBold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  13.verticalSpace,
                  Text(
                    user.bio ?? '-',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: Typo.regular,
                      color: Colors.black87,
                    ),
                  ),
                  35.verticalSpace,

                  // ---------- PERSONAL DETAILS ----------
                  _sectionCard("Personal Details", [
                    _profileDetail(
                      "Full Name",
                      isPaymentdone == true
                          ? user.fullname!
                          : "${user.fullname!.split(" ").first} ${user.fullname!.split(" ").last[0]}",
                      false,
                    ),
                    _profileDetail("Age", user.age?.toString() ?? '-', false),
                    _profileDetail("Gender", user.gender ?? '-', false),
                    _profileDetail(
                      "Date of Birth",
                      user.dateOfBirth != null
                          ? user.dateOfBirth!.split('T').first
                          : '-',
                      false,
                    ),
                    _profileDetail("Religion", user.religion ?? '-', false),
                    _profileDetail("Caste", user.caste ?? '-', false),
                    _profileDetail(
                      "Mother Tongue",
                      user.motherTongue ?? '-',
                      false,
                    ),
                    _profileDetail(
                      "Nationality",
                      user.nationality ?? '-',
                      false,
                    ),
                    _profileDetail(
                      "Birth Place",
                      user.birthPlace ?? '-',
                      false,
                    ),
                    _profileDetail("Zodiac", user.zodiac ?? '-', false),
                    _profileDetail(
                      "Birth Time",
                      user.birthTime != null
                          ? user.birthTime!.split(':').take(2).join(':')
                          : '-',
                      false,
                    ),
                  ], icon: Icons.person),

                  // ---------- ACADEMICS & PROFESSION ----------
                  _sectionCard("Academics & Profession", [
                    _profileDetail("Education", user.education ?? '-', false),
                    _profileDetail("Profession", user.profession ?? '-', false),
                    _profileDetail(
                      "Work Location",
                      user.workLocation ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Permanent Location",
                      user.district ?? '-',
                      true,
                    ),
                  ], icon: Icons.school),

                  // ---------- LIFESTYLE & PREFERENCES ----------
                  _sectionCard("Lifestyle & Preferences", [
                    _profileDetail("Diet", user.dite ?? '-', true),
                    _profileDetail(
                      "Smoking Habit",
                      user.smokingHabit ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Drinking Habit",
                      user.drinkingHabit ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Fitness Activity",
                      user.fitnessActivity ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Sleep Pattern",
                      user.sleepPattern ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Travel Preferences",
                      user.travelPreferences ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Pet Friendly",
                      user.petFriendly ?? '-',
                      true,
                    ),
                    _profileDetail(
                      "Daily Routine",
                      user.dailyRoutine ?? '-',
                      true,
                    ),
                  ], icon: Icons.favorite),

                  // ---------- HOBBIES ----------
                  _sectionCard("Hobbies", [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: user.hobbies!
                          .map(
                            (h) => Chip(
                              label: Text(h.hobbyName ?? '-'),
                              backgroundColor: AppColors.primaryLight,
                            ),
                          )
                          .toList(),
                    ),
                  ], icon: Icons.sports_handball),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- _sectionCard ---
  Widget _sectionCard(String title, List<Widget> children, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Row(
          children: [
            if (icon != null) Icon(icon, size: 22),
            if (icon != null) 8.widthBox,
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: Typo.playfairSemiBold,
              ),
            ),
          ],
        ),
        12.verticalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }

  // --- _profileDetail ---

  Widget _profileDetail(String label, String value, bool hide) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: Typo.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Text(
                  ": $value",
                  style: TextStyle(fontFamily: Typo.medium, fontSize: 16.sp),
                ),

                if (hide)
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- _buildTag ---
  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  statusBuilder() {
    return BlocListener<MasterBloc, MasterState>(
      listener: (context, state) {
        bool paid = false;
        if (state is GetProfileStatusLoadedState) {
          paid = state.user.paymentDone != 0;
          isPaymentdone = paid;
        }
        // return  SizedBox();
      },
    );
  }
}
