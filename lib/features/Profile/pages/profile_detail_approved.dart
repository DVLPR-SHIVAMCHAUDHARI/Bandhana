import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/typography.dart';

import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_bloc.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_event.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_state.dart';
import 'package:MilanMandap/features/Profile/model/user_detail_model.dart';
import 'package:MilanMandap/features/Requests/bloc/request_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailedApprovedScreen extends StatelessWidget {
  const ProfileDetailedApprovedScreen({
    super.key,
    required this.mode,
    required this.id,
    required this.match,
  });

  final String mode;
  final String id;
  final String match;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProfileDetailApprovedBloc()..add(GetUserDetailById(id)),
        ),
        BlocProvider(create: (_) => RequestBloc()),
      ],
      child: Scaffold(
        body: SafeArea(
          top: false,
          child:
              BlocBuilder<
                ProfileDetailApprovedBloc,
                ProfileDetailApprovedState
              >(
                builder: (context, state) {
                  if (state is ProfileDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileDetailError) {
                    return Center(child: Text(state.message));
                  }

                  UserDetailModel? user;

                  if (state is ProfileDetailLoaded) {
                    user = state.user;
                  } else if (state is SwitchImageState) {
                    user = state.user;
                  } else if (state is FavoriteToggledState) {
                    user = state.user;
                  }

                  if (user != null) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMainImage(context, user),
                          Transform.translate(
                            offset: Offset(0, -40),
                            child: _buildAvatarStack(context, user),
                          ),
                          _buildProfileDetails(user),
                          20.verticalSpace,
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
        ),
        // bottomNavigationBar: buildBottombar(context),
      ),
    );
  }

  // SafeArea buildBottombar(BuildContext context) {
  //   return SafeArea(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
  //       ),
  //       child: mode == 'viewOther'
  //           ? Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () {
  //                       showDialog(
  //                         context: context,
  //                         builder: (context) => CompatibilityDialog(),
  //                       );
  //                     },
  //                     style: OutlinedButton.styleFrom(
  //                       side: BorderSide(color: AppColors.primary),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(20.r),
  //                       ),
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: 24.w,
  //                         vertical: 14.h,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       "Check Match",
  //                       style: TextStyle(
  //                         color: AppColors.primary,
  //                         fontFamily: Typo.bold,
  //                         fontSize: 16.sp,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 10.widthBox,
  //                 Expanded(
  //                   child:
  //                       BlocConsumer<
  //                         ProfileDetailApprovedBloc,
  //                         ProfileDetailApprovedState
  //                       >(
  //                         listener: (context, state) {
  //                           if (state is SendRequestLoadedState) {
  //                             router.pushNamed(Routes.messageRequested.name);
  //                           } else if (state is SendRequestErrorState) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(content: Text(state.message)),
  //                             );
  //                           }
  //                         },
  //                         builder: (context, state) {
  //                           if (state is SendRequestLoadingState) {
  //                             return Center(
  //                               child: CircularProgressIndicator(
  //                                 color: AppColors.primary,
  //                               ),
  //                             );
  //                           }

  //                           return InkWell(
  //                             onTap: () {
  //                               if (localDb.getUserData()!.paymentDone == 0) {
  //                                 router.pushNamed(Routes.choosePlan.name);
  //                               } else {
  //                                 context.read<ProfileDetailApprovedBloc>().add(
  //                                   SendRequestEvent(id),
  //                                 );
  //                               }
  //                             },
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     blurRadius: 24.r,
  //                                     offset: Offset(4, 8),
  //                                     color: AppColors.primaryOpacity,
  //                                   ),
  //                                 ],
  //                                 gradient: AppColors.buttonGradient,
  //                                 borderRadius: BorderRadius.circular(20.r),
  //                               ),
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 32.w,
  //                                 vertical: 14.h,
  //                               ),
  //                               child: Text(
  //                                 textAlign: TextAlign.center,
  //                                 "Show Interest",
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontFamily: Typo.bold,
  //                                   fontSize: 16.sp,
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                 ),
  //               ],
  //             )
  //           : mode == "incomingRequest"
  //           ? Row(
  //               children: [
  //                 Expanded(
  //                   child: BlocConsumer<RequestBloc, RequestState>(
  //                     listener: (context, state) {
  //                       if (state is RejectRequestSuccessState) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                             content: Text("Request rejected successfully"),
  //                           ),
  //                         );
  //                         router.goNamed(Routes.request.name);
  //                       } else if (state is RejectRequestErrorState) {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           SnackBar(content: Text("Error: ${state.error}")),
  //                         );
  //                       }
  //                     },
  //                     builder: (context, state) {
  //                       if (state is RejectRequestLoadingState) {
  //                         return Center(
  //                           child: CircularProgressIndicator(
  //                             color: AppColors.primary,
  //                           ),
  //                         );
  //                       }
  //                       return OutlinedButton(
  //                         onPressed: () {
  //                           context.read<RequestBloc>().add(
  //                             RejectRecievedRequest(userId: int.parse(id)),
  //                           );
  //                         },
  //                         style: OutlinedButton.styleFrom(
  //                           side: BorderSide(color: AppColors.primary),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(20.r),
  //                           ),
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 24.w,
  //                             vertical: 14.h,
  //                           ),
  //                         ),
  //                         child: Text(
  //                           "Reject",
  //                           style: TextStyle(
  //                             color: AppColors.primary,
  //                             fontFamily: Typo.bold,
  //                             fontSize: 16.sp,
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 10.horizontalSpace,
  //                 Expanded(
  //                   child:
  //                       BlocConsumer<
  //                         ProfileDetailApprovedBloc,
  //                         ProfileDetailApprovedState
  //                       >(
  //                         listener: (context, state) {
  //                           if (state is AcceptRequestLoadedState) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(
  //                                 content: Text(
  //                                   "Request accepted successfully",
  //                                 ),
  //                               ),
  //                             );
  //                             router.pushNamed(Routes.chatList.name);
  //                           } else if (state is AcceptRequestErrorState) {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: Text("Error: ${state.message}"),
  //                               ),
  //                             );
  //                           }
  //                         },
  //                         builder: (context, state) {
  //                           if (state is AcceptRequestLoadingState) {
  //                             return Center(
  //                               child: CircularProgressIndicator(
  //                                 color: AppColors.primary,
  //                               ),
  //                             );
  //                           }
  //                           return InkWell(
  //                             onTap: () {
  //                               context.read<ProfileDetailApprovedBloc>().add(
  //                                 AcceptRequestEvent(id),
  //                               );
  //                             },
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     blurRadius: 24.r,
  //                                     offset: Offset(4, 8),
  //                                     color: AppColors.primaryOpacity,
  //                                   ),
  //                                 ],
  //                                 gradient: AppColors.buttonGradient,
  //                                 borderRadius: BorderRadius.circular(20.r),
  //                               ),
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 32.w,
  //                                 vertical: 14.h,
  //                               ),
  //                               child: Text(
  //                                 textAlign: TextAlign.center,
  //                                 "Accept Request",
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontFamily: Typo.bold,
  //                                   fontSize: 16.sp,
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                 ),
  //               ],
  //             )
  //           : OutlinedButton(
  //               onPressed: () {},
  //               style: OutlinedButton.styleFrom(
  //                 side: BorderSide(color: AppColors.primary),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20.r),
  //                 ),
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 24.w,
  //                   vertical: 14.h,
  //                 ),
  //               ),
  //               child: Text(
  //                 "Withdraw Request",
  //                 style: TextStyle(
  //                   color: AppColors.primary,
  //                   fontFamily: Typo.bold,
  //                   fontSize: 16.sp,
  //                 ),
  //               ),
  //             ),
  //     ),
  //   );
  // }

  Widget _buildMainImage(BuildContext context, UserDetailModel user) {
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    return BlocBuilder<ProfileDetailApprovedBloc, ProfileDetailApprovedState>(
      builder: (context, state) {
        String imageUrl;
        int centerIndex = 3;
        bool isFavorite = false;

        if (state is ProfileDetailLoaded) {
          isFavorite = state.isFavorite;
        } else if (state is FavoriteToggledState) {
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
                          mode == ProfileMode.viewOther.name
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
                          context.read<ProfileDetailApprovedBloc>().add(
                            ToggleFavoriteEvent(),
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
                    "${user.profileDetails!.fullname}, ${user.profileSetup!.age}",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: Typo.playfairDisplayRegular,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    "${user.profileSetup!.professionName} · ${user.profileDetails!.district}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                  ),
                  12.verticalSpace,
                  Wrap(
                    spacing: 8.w,
                    children: List.generate(
                      user.profileDetails!.hobbies!.length,
                      (index) => _buildTag(
                        "#${user.profileDetails!.hobbies![index].hobbyName}",
                      ),
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

  Widget _buildAvatarStack(BuildContext context, UserDetailModel user) {
    final List<String?> avatars = [
      user.profileSetup!.profileUrl1,
      user.profileSetup!.profileUrl2,
      user.profileSetup!.profileUrl3,
      user.profileSetup!.profileUrl4,
      user.profileSetup!.profileUrl5,
    ];

    const int centerIndex = 3;

    return SizedBox(
      height: 160.h,
      child: BlocBuilder<ProfileDetailApprovedBloc, ProfileDetailApprovedState>(
        builder: (context, state) {
          List<Map<String, dynamic>> avatarPositions = List.generate(
            avatars.length,
            (index) => {
              'index': index,
              'url': avatars[index] ?? '',
              'top': index == centerIndex
                  ? -40.0
                  : index == 1 || index == 2
                  ? -20.0
                  : 20.0,
              'left': index == 0
                  ? 0.0
                  : index == 1
                  ? 60.w
                  : index == 2
                  ? null
                  : index == 3
                  ? MediaQuery.sizeOf(context).width * 0.32.w
                  : null,
              'right': index == 2
                  ? 60.w
                  : index == 4
                  ? 0.0
                  : null,
              'size': index == centerIndex ? 152.h : 100.h,
            },
          );

          int highlightedIndex = centerIndex;

          if (state is SwitchImageState) {
            avatarPositions = state.avatars.map((avatar) {
              int idx = avatar['index'];
              return {
                ...avatar,
                'top': idx == centerIndex
                    ? -40.0
                    : idx == 1 || idx == 2
                    ? -15.0
                    : 20.0,
                'left': avatarPositions.firstWhere(
                  (e) => e['index'] == idx,
                )['left'],
                'right': avatarPositions.firstWhere(
                  (e) => e['index'] == idx,
                )['right'],
                'size': idx == centerIndex ? 152.h : 100.h,
              };
            }).toList();
            highlightedIndex = centerIndex;
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
                    if (index != highlightedIndex) {
                      context.read<ProfileDetailApprovedBloc>().add(
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
                        color: index == highlightedIndex
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

  Widget _buildProfileDetails(UserDetailModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          _sectionCard("Personal Information", [
            _profileDetail("Full Name", user.profileDetails!.fullname!),
            _profileDetail(
              "Date of Birth",
              user.profileDetails!.dateOfBirth ?? '',
            ),
            _profileDetail("Age", "${user.profileSetup!.age}"),
            _profileDetail("Gender", user.profileDetails!.genderName!),
          ]),
          _sectionCard("Education & Career", [
            _profileDetail("Education", user.profileSetup!.educationName ?? ''),
            _profileDetail(
              "Profession",
              user.profileSetup!.professionName ?? '',
            ),
            _profileDetail(
              "Annual Income",
              user.profileSetup!.salaryName ?? '',
            ),
          ]),
          _sectionCard("Location", [
            _profileDetail(
              "Country",
              user.profileDetails!.nationalityName ?? '',
            ),
            _profileDetail("State", user.profileDetails!.stateName ?? ''),
            _profileDetail("District", user.profileDetails!.districtName ?? ''),
            _profileDetail("City", user.profileDetails!.districtName ?? ''),
          ]),
          _sectionCard("Hobbies", [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.profileDetails!.hobbies!
                  .map((h) => Chip(label: Text(h.hobbyName!)))
                  .toList(),
            ),
          ]),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children, {IconData? icon}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Row(
                children: [
                  if (icon != null)
                    Icon(icon, size: 20.sp, color: AppColors.primary),
                  if (icon != null) 6.horizontalSpace,
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: Typo.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            if (title.isNotEmpty) 10.verticalSpace,
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _profileDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: Typo.regular,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: Typo.medium,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

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
