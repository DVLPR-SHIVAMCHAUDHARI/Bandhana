import 'package:MilanMandap/core/const/asset_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.colorr});
  final colorr;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.26.h,

      child: Image.asset(
        fit: BoxFit.cover,
        height: 180,
        Urls.igMilanMandapComplete,
        color: colorr,
      ),
    );
  }
}
