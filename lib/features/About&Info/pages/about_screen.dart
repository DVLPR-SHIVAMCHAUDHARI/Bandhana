import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/about_bloc.dart';
import '../bloc/about_event.dart';
import '../bloc/about_state.dart';
import '../repository/about_info_repo.dart';
import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// Launch email
  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Launch phone call
  void _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutBloc(AboutInfoRepo())..add(FetchAboutEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<AboutBloc, AboutState>(
          builder: (context, state) {
            if (state is AboutLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AboutLoaded) {
              final about = state.about;
              final statements = [
                about.statement1,
                about.statement2,
                about.statement3,
                about.statement4,
              ];

              return Stack(
                children: [
                  // Curved top background
                  Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                  ),

                  // Content card
                  SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: 80.h,
                        left: 20.w,
                        right: 20.w,
                        bottom: 20.h,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // App name / header
                              Center(
                                child: Text(
                                  "About Milan Mandap",
                                  style: TextStyle(
                                    fontFamily: Typo.bold,
                                    fontSize: 20.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Statements with bullet points
                              ...statements.map(
                                (s) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Bullet icon
                                      Container(
                                        margin: EdgeInsets.only(top: 6.h),
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      // Statement text
                                      Expanded(
                                        child: Text(
                                          s,
                                          style: TextStyle(
                                            fontFamily: Typo.medium,
                                            fontSize: 16.sp,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Divider(),
                              SizedBox(height: 12.h),

                              // Contact header
                              Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontFamily: Typo.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              // Phone row
                              InkWell(
                                onTap: () => _launchPhone(about.mobileNo),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 12.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        about.mobileNo,
                                        style: TextStyle(
                                          fontFamily: Typo.medium,
                                          fontSize: 16.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),

                              // Email row
                              InkWell(
                                onTap: () => _launchEmail(about.email),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 12.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        about.email,
                                        style: TextStyle(
                                          fontFamily: Typo.medium,
                                          fontSize: 16.sp,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is AboutError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
