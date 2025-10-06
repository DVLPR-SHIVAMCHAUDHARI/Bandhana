import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/features/Subscription/bloc/subscription_bloc.dart';
import 'package:MilanMandap/features/Subscription/bloc/subscription_event.dart';
import 'package:MilanMandap/features/Subscription/bloc/subscription_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ChooseYourPlanScreen extends StatefulWidget {
  const ChooseYourPlanScreen({super.key});

  @override
  State<ChooseYourPlanScreen> createState() => _ChooseYourPlanScreenState();
}

class _ChooseYourPlanScreenState extends State<ChooseYourPlanScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    // Register callbacks
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.code} - ${response.message}"),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  void openCheckout({required amount}) {
    var options = {
      'key': 'rzp_test_RLOK74js6vkzZk',
      'amount': amount, // Amount in paise
      'name': 'MilanMandap',
      'description': 'Test Payment',
      'prefill': {
        'contact': '9021262585',
        'email': 'dev.shivamchaudhari@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

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
              onPressed: () => context.pop(),
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
          body: SafeArea(
            child: Padding(
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
                                  color: isMonthly
                                      ? Colors.white
                                      : Colors.black,
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
                                  color: !isMonthly
                                      ? Colors.white
                                      : Colors.black,
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
                                Icon(
                                  Icons.star_border,
                                  color: Color(0xFFE94F64),
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text("• $e"),
                              ),
                            ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (state is SwitchPlanState) {
                                openCheckout(
                                  amount: state.selectedIndex == 0
                                      ? "29900"
                                      : "249900",
                                );
                              } else {
                                openCheckout(amount: 29900);
                              }

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
          ),
        );
      },
    );
  }
}
