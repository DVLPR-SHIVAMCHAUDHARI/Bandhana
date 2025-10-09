import 'package:MilanMandap/core/const/app_theme.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/services/tokenservice.dart';
// Note: This 'hide' suggests a potential import conflict, which is typically resolved by adjusting the BLoC's import path.
import 'package:MilanMandap/features/master_apis/bloc/master_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Assuming 'localDb' is a global instance of LocalDbService and 'token' is TokenServices.instance

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localDb.init(); // Initialize the LocalDbService (Hive)

  // Example commented-out code for token and user setup
  // token.storeTokens(
  //   accessToken:
  //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7InVzZXJfaWQiOjEzLCJpbnZhbGlkX290cCI6MCwidXNlcl9kYXRhIjp7ImlkIjoxMywiZnVsbG5hbWUiOiJQdXJ2YSBMb2toYW5kZSIsImNyZWF0ZWRfYXQiOiIyMDI1LTA5LTI2IDEyOjA0OjUwLjAwMDAwMCIsInBheW1lbnRfZG9uZSI6MCwibW9iaWxlX251bWJlciI6Iis5MTkwMjEwNzYyOTQiLCJwcm9maWxlX3NldHVwIjoxLCJmYW1pbHlfZGV0YWlscyI6MSwicHJvZmlsZV9kZXRhaWxzIjoxLCJwYXJ0bmVyX2xpZmVfc3R5bGUiOjEsInBhcnRuZXJfZXhwZWN0YXRpb25zIjoxLCJkb2N1bWVudF92ZXJpZmljYXRpb24iOjEsImlzX2RvY3VtZW50X3ZlcmlmaWNhdGlvbiI6MX0sImVycm9yIjpmYWxzZSwiY29kZSI6IjAwMCJ9LCJpYXQiOjE3NTk3NDk0ODB9.x3V-BXh5n8A4DH2mI3o2_KEYdXfrCoZt7qQ00-oNTO0",
  // );
  // localDb.saveUserData(
  //   UserModel.fromJson({
  //     "user_id": 13,
  //     "district": "Nashik",
  //     "fullname": "Purva Lokhande",
  //     "payment_done": 0,
  //     "mobile_number": "+919021076294",
  //     "profile_setup": 1,
  //     "profile_url_1":
  //         "https://unimeshtesting.s3.ap-south-1.amazonaws.com/bandhana/profile_document/p1_13-1758868687266.jpg",
  //     "family_details": 1,
  //     "profile_details": 1,
  //     "partner_life_style": 1,
  //     "partner_expectations": 1,
  //     "document_verification": 1,
  //     "is_document_verification": 1,
  //     "error": false,
  //     "code": "000",
  //   }),
  // );

  await token.load(); // Load token from storage

  print(token.accessToken);

  logger.d("Stored token (in TokenServices): ${TokenServices().accessToken}");
  logger.d("Saved user in Hive: ${localDb.getUserData()}");
  runApp(const MilanMandap());
}

class MilanMandap extends StatelessWidget {
  const MilanMandap({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MasterBloc()),

            // Injecting the localDbService dependency into the ChatSystemBloc
            // BlocProvider<ChatSystemBloc>(
            //   create: (context) => ChatSystemBloc(localDbService: localDb),
            // ),
          ],
          child: MaterialApp.router(
            color: Colors.white,
            title: "MilanMandap",
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            // Assuming 'router' is defined elsewhere and is a GoRouter or similar config
            routerConfig: router,
          ),
        );
      },
    );
  }
}
