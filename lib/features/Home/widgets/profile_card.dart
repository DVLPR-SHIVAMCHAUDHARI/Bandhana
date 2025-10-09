import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/numberextension.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:MilanMandap/features/master_apis/bloc/master_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    this.image,
    this.age,
    this.district,
    this.match,
    this.name,
    this.profession,
    this.hobbies,
    required this.id,
    this.isFavorite,
    this.onFavoriteToggle,
    required this.onSkip,
    required this.viewProfile,
  });
  final VoidCallback? onSkip;
  final VoidCallback? viewProfile;

  final int? isFavorite;
  final String? image;
  final String? id;
  final String? match;
  final String? name;
  final String? age;
  final String? profession;
  final String? district;
  final onFavoriteToggle;
  final List? hobbies;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late int? isFavoriteLocal;

  @override
  void initState() {
    super.initState();
    isFavoriteLocal = widget.isFavorite;
  }

  void _toggleFavorite() {
    final add = isFavoriteLocal == 0;
    // Optimistically update UI
    setState(() {
      isFavoriteLocal = add ? 1 : 0;
    });

    // Call bloc
    context.read<MasterBloc>().add(
      ToggleFavoriteEvent(userId: widget.id!, add: add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      height: 500.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: CachedNetworkImageProvider("${widget.image}"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
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
            // Top right fav icon
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: _toggleFavorite,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: isFavoriteLocal == null || isFavoriteLocal == 0
                      ? Icon(Icons.favorite_outline, color: Colors.black)
                      : Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 10.w,
                //     vertical: 4.h,
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.pinkAccent,
                //     borderRadius: BorderRadius.circular(20.r),
                //   ),
                //   child: Text(
                //     "☆ Pro User",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontFamily: Typo.medium,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 10.sp,
                //     ),
                //   ),
                // ),
                // 10.horizontalSpace,
                Text(
                  "${widget.match} % Match" ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: Typo.bold,
                  ),
                ),
              ],
            ),

            10.verticalSpace,

            // Name + Age
            Text(
              "${widget.name}, ${widget.age}",
              style: TextStyle(
                fontSize: 28.sp,
                fontFamily: Typo.playfairDisplayRegular,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            5.verticalSpace,

            // Occupation + Location
            Text(
              "${widget.profession} · ${widget.district}",
              style: TextStyle(fontSize: 16.sp, color: Colors.white70),
            ),

            12.verticalSpace,

            // Tags
            Wrap(
              runSpacing: 8.h,
              spacing: 8.w,
              children: List.generate(
                widget.hobbies!.length,
                (index) => _buildTag("#${widget.hobbies![index]}"),
              ),
            ),
            20.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<MasterBloc>().add(
                        SkipProfileEvent(userId: widget.id!),
                      );
                      widget.onSkip?.call();
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
                      "Skip",
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
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: widget.viewProfile,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.buttonGradient,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 14.h,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Typo.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // class ProfileCard extends StatelessWidget {
  //   const ProfileCard({
  //     super.key,
  //     this.image,
  //     this.age,
  //     this.district,
  //     this.match,
  //     this.name,
  //     this.profession,
  //     this.hobbies,
  //     required this.id,
  //     required this.isFavorite,
  //     required this.onFavoriteToggle, // callback
  //   });
  //   final int? isFavorite;
  //   final String? image;
  //   final String? id;
  //   final String? match;
  //   final String? name;
  //   final String? age;
  //   final String? profession;
  //   final String? district;
  //   final VoidCallback onFavoriteToggle; // 🟢 new

  //   final List? hobbies;

  //   @override
  //   Widget build(BuildContext context) {
  //     return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
  //       height: 500.h,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(24.r),
  //         image: DecorationImage(
  //           image: CachedNetworkImageProvider("$image"),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(24.r),
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               Colors.transparent,
  //               Colors.black.withOpacity(0.7), // dark overlay bottom
  //             ],
  //           ),
  //         ),
  //         padding: EdgeInsets.all(20.w),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Top right fav icon
  //             Align(
  //               alignment: Alignment.topRight,
  //               child: InkWell(
  //                 onTap: () {
  //                   final add = isFavorite == 0; // toggle logic
  //                   context.read<MasterBloc>().add(
  //                     ToggleFavoriteEvent(userId: id!, add: add),
  //                   );
  //                 },
  //                 child: CircleAvatar(
  //                   backgroundColor: Colors.white,
  //                   child: isFavorite == null || isFavorite == 0
  //                       ? Icon(Icons.favorite_outline, color: Colors.black)
  //                       : Icon(Icons.favorite, color: Colors.red),
  //                 ),
  //               ),
  //             ),

  //             const Spacer(),

  //             // Pro user + Match
  //             Row(
  //               children: [
  //                 // Container(
  //                 //   padding: EdgeInsets.symmetric(
  //                 //     horizontal: 10.w,
  //                 //     vertical: 4.h,
  //                 //   ),
  //                 //   decoration: BoxDecoration(
  //                 //     color: Colors.pinkAccent,
  //                 //     borderRadius: BorderRadius.circular(20.r),
  //                 //   ),
  //                 //   child: Text(
  //                 //     "☆ Pro User",
  //                 //     style: TextStyle(
  //                 //       color: Colors.white,
  //                 //       fontFamily: Typo.medium,
  //                 //       fontWeight: FontWeight.bold,
  //                 //       fontSize: 10.sp,
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // 10.horizontalSpace,
  //                 Text(
  //                   "$match % Match" ?? "",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w600,
  //                     fontFamily: Typo.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             10.verticalSpace,

  //             // Name + Age
  //             Text(
  //               "$name, $age",
  //               style: TextStyle(
  //                 fontSize: 28.sp,
  //                 fontFamily: Typo.playfairDisplayRegular,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),

  //             5.verticalSpace,

  //             // Occupation + Location
  //             Text(
  //               "$profession · $district",
  //               style: TextStyle(fontSize: 16.sp, color: Colors.white70),
  //             ),

  //             12.verticalSpace,

  //             // Tags
  //             Wrap(
  //               spacing: 8.w,
  //               children: List.generate(
  //                 hobbies!.length,
  //                 (index) => _buildTag("#${hobbies![index]}"),
  //               ),
  //             ),
  //             20.verticalSpace,

  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () {},
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
  //                       "Skip",
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
  //                   child: Material(
  //                     color: Colors.transparent,
  //                     borderRadius: BorderRadius.circular(20.r),
  //                     child: InkWell(
  //                       borderRadius: BorderRadius.circular(20.r),
  //                       onTap: () {
  //                         router.pushNamed(
  //                           Routes.profileDetail.name,
  //                           pathParameters: {
  //                             "mode": ProfileMode.viewOther.name,
  //                             "id": id.toString(),
  //                             "match": match.toString(),
  //                           },
  //                         );
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           gradient: AppColors.buttonGradient,
  //                           borderRadius: BorderRadius.circular(20.r),
  //                         ),
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 32.w,
  //                           vertical: 14.h,
  //                         ),
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           "View Profile",
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontFamily: Typo.bold,
  //                             fontSize: 16.sp,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontFamily: Typo.medium,
        ),
      ),
    );
  }
}
