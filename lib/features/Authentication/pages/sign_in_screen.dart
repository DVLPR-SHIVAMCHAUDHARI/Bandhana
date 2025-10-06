import 'package:MilanMandap/core/const/app_colors.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/const/snack_bar.dart';
import 'package:MilanMandap/core/const/typography.dart';
import 'package:MilanMandap/core/sharedWidgets/applogocomplete.dart';
import 'package:MilanMandap/core/sharedWidgets/background_widget.dart';
import 'package:MilanMandap/core/sharedWidgets/primary_button.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_bloc.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_event.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_state.dart';
import 'package:MilanMandap/features/Authentication/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedCode = '+91';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignInLoadedState) {
            final number = "$selectedCode${phoneController.text}";
            router.goNamed(
              Routes.otp.name,
              pathParameters: {"number": number, "prev": "signin"},
            );
          }

          if (state is SignInErrorState) {
            snackbar(
              context,
              color: Colors.red,
              message: state.message,
            ); //////this isnt working
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: BackgroundWidget(
                top: 232.h,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        40.verticalSpace,

                        // ✅ Logo
                        AppLogo(colorr: AppColors.primary),
                        14.verticalSpace,

                        // Title
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontFamily: Typo.playfairSemiBold,
                          ),
                        ),
                        40.verticalSpace,

                        // ✅ Phone field with validation
                        PhoneNumberField(
                          title: "Enter Mobile No.",
                          controller: phoneController,
                          initialCountryCode: "+91",
                          onCountryChanged: (code) => selectedCode = code,
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
                        24.verticalSpace,

                        // ✅ Button
                        state is SignInLoadingState
                            ? const CircularProgressIndicator()
                            : PrimaryButton(
                                text: "Sign In",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final number =
                                        "$selectedCode${phoneController.text}";
                                    context.read<AuthBloc>().add(
                                      SignInEvent(phone: number),
                                    );
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),

                        16.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () => router.goNamed(Routes.signup.name),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
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
          );
        },
      ),
    );
  }
}
