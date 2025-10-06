import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/applogocomplete.dart';
import 'package:MilanMandap/core/sharedWidgets/apptextfield.dart';
import 'package:MilanMandap/core/sharedWidgets/background_widget.dart';
import 'package:MilanMandap/core/sharedWidgets/primary_button.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_bloc.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_event.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_state.dart';
import 'package:MilanMandap/features/Authentication/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameField = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedCode = "+91";
  static bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpLoadedState) {
            // Sign up success → navigate to OTP
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            final number = "$selectedCode${phoneController.text}";
            router.goNamed(
              Routes.otp.name,
              pathParameters: {"number": number, "prev": "signup"},
            );
          }

          if (state is SignUpErrorState) {
            // Sign up error
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: BackgroundWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24).w,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          50.verticalSpace,
                          // Logo row
                          AppLogo(colorr: AppColors.primary),

                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32.sp,
                              fontFamily: Typo.playfairSemiBold,
                            ),
                          ),
                          42.verticalSpace,
                          AppTextField(
                            title: 'Name',
                            hint: "Name",
                            controller: nameField,
                            isRequired: true,

                            validator: (p0) {
                              if (p0 == null || p0.trim().isEmpty) {
                                return "Please enter your name";
                              }
                              if (p0.trim().length < 3) {
                                return "Name must be at least 3 characters";
                              }
                              return null;
                            },
                          ),
                          16.verticalSpace,
                          PhoneNumberField(
                            title: "Enter Mobile No.",
                            controller: phoneController,
                            initialCountryCode: "+91",
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your phone number";
                              }
                              if (value.trim().length < 10) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          16.verticalSpace,
                          Row(
                            children: [
                              SizedBox(
                                height: 16.h,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  checkColor: Colors.white,
                                  activeColor: Colors.black,
                                  value: isSelected,
                                  onChanged: (v) {
                                    setState(() {
                                      isSelected = v!;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                "I agree to the ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  router.pushNamed(Routes.privacyPolicy.name);
                                },
                                child: Text(
                                  "Terms & Privacy Policy",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          24.verticalSpace,

                          // Sign Up Button
                          state is SignUpLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : PrimaryButton(
                                  text: "Sign Up",
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (!isSelected) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Please accept Terms & Privacy Policy",
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final number =
                                          "$selectedCode${phoneController.text}";

                                      context.read<AuthBloc>().add(
                                        SignUpEvent(
                                          name: nameField.text,
                                          phone: number,
                                        ),
                                      );

                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                ),

                          16.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already a member? "),
                              GestureDetector(
                                onTap: () => router.goNamed(Routes.signin.name),
                                child: Text(
                                  "Sign In",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.pink.shade400,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
