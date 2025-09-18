import 'package:bandhana/core/services/local_db_sevice.dart';
import 'package:bandhana/core/services/request_permission_service.dart';
import 'package:bandhana/core/services/tokenservice.dart';
import 'package:bandhana/features/About&Info/pages/about_screen.dart';
import 'package:bandhana/features/About&Info/pages/privacy_policy_screen.dart';
import 'package:bandhana/features/Authentication/pages/otp_verification_screen.dart';
import 'package:bandhana/features/Authentication/pages/sign_in_screen.dart';
import 'package:bandhana/features/Authentication/pages/signup_screen.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_bloc.dart';
import 'package:bandhana/features/BasicCompatiblity/pages/basic_compablity_screen1.dart';
import 'package:bandhana/features/BasicCompatiblity/pages/basic_compablity_screen2.dart';
import 'package:bandhana/features/Chat/pages/chat_list_screen.dart';
import 'package:bandhana/features/Chat/pages/chat_screen.dart';
import 'package:bandhana/features/Discover/pages/discover_screen.dart';
import 'package:bandhana/features/DocumentVerification/pages/document_verification_screen.dart';
import 'package:bandhana/features/Home/pages/homescreen.dart';
import 'package:bandhana/features/HomeAnimation/pages/home_animation_screen.dart';
import 'package:bandhana/features/Onboarding/pages/first_welcome_screen.dart';
import 'package:bandhana/features/Onboarding/pages/onboarding_screen.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/pages/message_requested_screen.dart';
import 'package:bandhana/features/Profile/pages/profile_detail_screen.dart';
import 'package:bandhana/features/Registration/pages/family_details_screen.dart';
import 'package:bandhana/features/Registration/pages/registration_screen.dart';
import 'package:bandhana/features/Requests/pages/request_screen.dart';
import 'package:bandhana/features/Subscription/bloc/subscription_bloc.dart';
import 'package:bandhana/features/Subscription/pages/choose_your_plans_screen.dart';
import 'package:bandhana/features/navbar/pages/navbar.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/pages/my_profile_screen.dart';
import 'package:bandhana/features/Registration/pages/profile_setup_screen.dart';
import 'package:bandhana/features/splashScreen/page/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

enum Routes {
  splash,
  onboard,
  signin,
  signup,
  otp,
  welcome,
  register,
  profilesetup,
  docVerification,
  compatablity1,
  compatablity2,
  homeAnimationScreen,
  navbar,
  homescreen,
  discover,
  request,
  chatList,
  profileDetail,
  messageRequested,
  choosePlan,
  myProfile,
  privacyPolicy,
  about,
  chat,
  familyDetails,
}

enum ProfileMode {
  viewOther, // viewing someone's profile → Show Interest
  incomingRequest, // user received a request → Accept/Reject
}

enum ProfileType { pro, normal }

final logger = Logger(
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, printTime: false),
);
LocalDbService localDb = LocalDbService();

RequestPermission permission = RequestPermission();
TokenServices token = TokenServices();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get appContext => navigatorKey.currentState!.context;

GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  // initialLocation: "docVerification",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => SplashScreen(),
      name: Routes.splash.name,
    ),
    GoRoute(
      path: "/onboard",
      builder: (context, state) => OnboardingScreen(),
      name: Routes.onboard.name,
    ),
    GoRoute(
      path: "/firstwelcome",
      builder: (context, state) => FirstWelcomeScreen(),
      name: Routes.welcome.name,
    ),
    GoRoute(
      path: "/signin",
      builder: (context, state) => SigninScreen(),
      name: Routes.signin.name,
      routes: [
        GoRoute(
          path: "otp/:number/:prev",
          builder: (context, state) => OtpVerificationScreen(
            number: state.pathParameters['number'] ?? "",
            prev: state.pathParameters['prev'] ?? "",
          ),
          name: Routes.otp.name,
        ),
        GoRoute(
          path: "signup",
          builder: (context, state) => SignupScreen(),
          name: Routes.signup.name,
        ),
      ],
    ),
    GoRoute(
      path: "/homeanimation",
      builder: (context, state) => HomeAnimationScreen(),
      name: Routes.homeAnimationScreen.name,
    ),
    ShellRoute(
      builder: (context, state, child) => Navbar(child: child),
      routes: [
        GoRoute(
          path: "/homescreen",
          builder: (context, state) => HomeScreen(),
          name: Routes.homescreen.name,
        ),
        GoRoute(
          path: "/discover",
          builder: (context, state) => DiscoverScreen(),
          name: Routes.discover.name,
        ),
        GoRoute(
          path: "/chatList",
          builder: (context, state) => ChatListScreen(),
          name: Routes.chatList.name,
        ),
        GoRoute(
          path: "/request",
          builder: (context, state) => RequestScreen(),
          name: Routes.request.name,
        ),
      ],
    ),
    GoRoute(
      path: "/profileDetail/:mode",
      builder: (context, state) => BlocProvider(
        create: (context) => ProfileDetailBloc(),
        child: ProfileDetailedScreen(
          mode: state.pathParameters['mode'] ?? "viewOther",
        ),
      ),
      name: Routes.profileDetail.name,
    ),
    GoRoute(
      path: "/messageRequested",
      builder: (context, state) => MessageRequestedScreen(),
      name: Routes.messageRequested.name,
    ),
    GoRoute(
      path: "/register",
      builder: (context, state) => RegistrationScreen(),
      name: Routes.register.name,
      routes: [
        GoRoute(
          path: "profilesetup",
          builder: (context, state) => ProfileSetupScreen(),
          name: Routes.profilesetup.name,
          routes: [
            GoRoute(
              path: "familyDetails",
              builder: (context, state) => FamilyDetailsScreen(),
              name: Routes.familyDetails.name,
              routes: [
                GoRoute(
                  path: "docVerification",
                  builder: (context, state) => DocumentVerificationScreen(),
                  name: Routes.docVerification.name,
                  routes: [
                    GoRoute(
                      name: Routes.compatablity1.name,
                      path: 'compatablity1',
                      builder: (context, state) => BlocProvider(
                        create: (_) => UserPreferencesBloc(),
                        child: BasicCompablityScreen1(),
                      ),

                      routes: [
                        GoRoute(
                          name: Routes.compatablity2.name,
                          path: 'compatablity2',
                          builder: (context, state) => BlocProvider(
                            create: (_) => UserPreferencesBloc(),
                            child: BasicCompablityScreen2(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: "/chat",
      builder: (context, state) => ChatScreen(),
      name: Routes.chat.name,
    ),
    GoRoute(
      path: "/choosePlan",
      builder: (context, state) => BlocProvider(
        create: (context) => SubscriptionBloc(),
        child: ChooseYourPlanScreen(),
      ),
      name: Routes.choosePlan.name,
    ),
    GoRoute(
      path: "/myProfile",
      builder: (context, state) => BlocProvider(
        create: (context) => ProfileSetupBloc(),
        child: MyProfileScreen(),
      ),
      name: Routes.myProfile.name,
    ),
    GoRoute(
      path: "/privacyPolicy", // fixed typo (was privayPolicy)
      builder: (context, state) => PrivacyPolicyScreen(),
      name: Routes.privacyPolicy.name,
    ),
    GoRoute(
      path: "/about",
      builder: (context, state) => AboutScreen(),
      name: Routes.about.name,
    ),
  ],
);
