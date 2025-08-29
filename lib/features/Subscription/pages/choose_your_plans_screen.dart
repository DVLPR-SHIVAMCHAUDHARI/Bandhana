import 'package:bandhana/core/const/app_colors.dart';
import 'package:bandhana/core/const/typography.dart';
import 'package:bandhana/features/Subscription/bloc/subscription_bloc.dart';
import 'package:bandhana/features/Subscription/bloc/subscription_event.dart';
import 'package:bandhana/features/Subscription/bloc/subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseYourPlanScreen extends StatelessWidget {
  const ChooseYourPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        int selectedIndex = 0; // default monthly
        if (state is SwitchPlanState) {
          selectedIndex = state.selectedIndex;
        }

        bool isMonthly = selectedIndex == 0;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Subscription",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                Text(
                  "Choose Your Plan",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: Typo.bold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.verticalSpace,
                Text(
                  "Tailored for your style, designed for your needs.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Typo.regular,
                    color: Colors.black54,
                  ),
                ),
                24.verticalSpace,

                // Toggle buttons
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8DCE1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 13.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<SubscriptionBloc>().add(
                            SwitchPlanEvent(0),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30.w,
                            ),
                            decoration: BoxDecoration(
                              color: isMonthly
                                  ? const Color(0xFFE94F64)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Monthly",
                              style: TextStyle(
                                fontFamily: Typo.semiBold,
                                fontSize: 18.sp,
                                color: isMonthly ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.read<SubscriptionBloc>().add(
                            SwitchPlanEvent(1),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isMonthly
                                  ? const Color(0xFFE94F64)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Yearly",
                              style: TextStyle(
                                color: !isMonthly ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Plan card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEDEF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.star_border, color: Color(0xFFE94F64)),
                              SizedBox(width: 6),
                              Text(
                                "Pro user",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE94F64),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE94F64),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isMonthly ? "₹299/month" : "₹2499/year",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      16.verticalSpace,

                      ...plans[isMonthly ? "Monthly" : "Yearly"]!
                          .split(',')
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text("• $e"),
                            ),
                          ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Handle proceed
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Choose & Proceed",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
