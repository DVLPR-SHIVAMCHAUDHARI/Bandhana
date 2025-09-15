import 'package:bandhana/core/const/app_theme.dart';
import 'package:bandhana/core/const/globals.dart';
import 'package:bandhana/core/services/local_db_sevice.dart';
import 'package:bandhana/core/services/tokenservice.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localDb.init();
  await token.load();

  print(token.accessToken);

  logger.d("Stored token (in TokenServices): ${TokenServices().accessToken}");
  logger.d("Saved user in Hive: ${localDb.getUserData()}");
  runApp(Bandhana());
}

class Bandhana extends StatelessWidget {
  const Bandhana({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => MasterBloc())],
          child: MaterialApp.router(
            color: Colors.white,
            title: "Bandhana",
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
