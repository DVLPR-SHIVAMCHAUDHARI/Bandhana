import 'package:bandhana/core/const/app_theme.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const Bandhana());
}

class Bandhana extends StatelessWidget {
  const Bandhana({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return MaterialApp.router(
          color: Colors.white,
          title: "Bandhana",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
