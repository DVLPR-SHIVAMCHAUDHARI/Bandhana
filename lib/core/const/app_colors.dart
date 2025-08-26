import 'package:flutter/cupertino.dart';

class AppColors {
  static final Gradient splashGradient = LinearGradient(
    colors: [Color(0xffFE8DA1), Color(0xffC2455C)],
  );
  static final Gradient mainGradient2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffFA6B9F), Color(0xffFA6C9F)],
  );
  static final Gradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xffFE8DA1), Color(0xffF01299)],
  );
  static final Gradient darkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xffDF5770), Color(0xff792F3D)],
  );
  static final Gradient compatiblityLightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffFC6B85), Color(0xffFFF3F5)],
  );

  static Color primary = Color(0xffDF5770);
  static Color primaryFC = Color(0xffFC6B85);

  static Color primaryOpacity = Color(0xffDF5770).withOpacity(0.14);
  static Color white = Color(0xffFFFFFF);
  static Color black = Color(0xff000000);
  static Color headingblack = Color(0xff383838);
  static Color otpGrey = Color(0xffD9D9D9);
  static Color navbarFill = Color(0xffEEEEEE).withOpacity(0.91);
}
