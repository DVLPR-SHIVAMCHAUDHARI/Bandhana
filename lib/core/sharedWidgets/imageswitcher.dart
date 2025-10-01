import 'package:bandhana/features/Profile/bloc_normal/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/bloc_normal/profile_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  final List<String?> avatars;
  final int centerIndex;
  final String name;
  final String age;
  final String profession;
  final List<String> hobbies;
  final void Function(int index) onAvatarTap;

  const ProfileHeader({
    super.key,
    required this.avatars,
    required this.centerIndex,
    required this.name,
    required this.age,
    required this.profession,
    required this.hobbies,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
      builder: (context, state) {
        List<Map<String, dynamic>> avatarPositions = List.generate(
          avatars.length,
          (index) => {
            'index': index,
            'url': avatars[index] ?? '',
            'top': index == centerIndex
                ? -40.0
                : index == 1 || index == 2
                ? -15.0
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

        // If bloc state has switched image, update urls
        if (state is SwitchImageState) {
          avatarPositions = state.avatars;
        }

        // Center image for header
        final String mainImageUrl = avatarPositions[centerIndex]['url'] ?? '';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Main image
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: mainImageUrl,
                  height: 550.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 500.h, color: Colors.grey[200]),
                  errorWidget: (_, __, ___) =>
                      Container(height: 500.h, color: Colors.grey),
                ),
                Container(
                  height: 570,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      50.verticalSpace,
                      Text(
                        "$name, $age",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        "$profession",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white70,
                        ),
                      ),
                      12.verticalSpace,
                      Wrap(
                        spacing: 8.w,
                        children: hobbies
                            .map((hobby) => _buildTag(hobby))
                            .toList(),
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),

            // Avatar stack
            SizedBox(
              height: 160.h,
              child: Stack(
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
                          onAvatarTap(index);
                        }
                      },
                      child: Container(
                        height: avatar['size'],
                        width: avatar['size'],
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: index == centerIndex
                                ? Colors.blue
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
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        "#$label",
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}
