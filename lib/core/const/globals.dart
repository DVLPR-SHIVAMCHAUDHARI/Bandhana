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
import 'package:bandhana/features/Discover/bloc/discover_bloc.dart';
import 'package:bandhana/features/Discover/pages/discover_screen.dart';
import 'package:bandhana/features/DocumentVerification/pages/document_verification_screen.dart';
import 'package:bandhana/features/Home/bloc/home_bloc.dart';
import 'package:bandhana/features/Home/pages/homescreen.dart';
import 'package:bandhana/features/HomeAnimation/pages/home_animation_screen.dart';
import 'package:bandhana/features/Onboarding/pages/first_welcome_screen.dart';
import 'package:bandhana/features/Onboarding/pages/onboarding_screen.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_bloc.dart';
import 'package:bandhana/features/Profile/pages/message_requested_screen.dart';
import 'package:bandhana/features/Profile/pages/profile_detail_screen.dart';
import 'package:bandhana/features/Registration/pages/edit_profile_screen.dart';
import 'package:bandhana/features/Registration/pages/family_details_screen.dart';
import 'package:bandhana/features/Registration/pages/registration_screen.dart';
import 'package:bandhana/features/Requests/bloc/request_bloc.dart';
import 'package:bandhana/features/Requests/pages/request_screen.dart';
import 'package:bandhana/features/Subscription/bloc/subscription_bloc.dart';
import 'package:bandhana/features/Subscription/pages/choose_your_plans_screen.dart';
import 'package:bandhana/features/master_apis/bloc/master_bloc.dart';
import 'package:bandhana/features/master_apis/bloc/master_event.dart';
import 'package:bandhana/features/navbar/pages/navbar.dart';
import 'package:bandhana/features/Registration/Bloc/profile_setup_bloc/profile_setup_bloc.dart';
import 'package:bandhana/features/Registration/pages/my_profile_screen.dart';
import 'package:bandhana/features/Registration/pages/profile_setup_screen.dart';
import 'package:bandhana/features/notification/pages/notifications_screen.dart';
import 'package:bandhana/features/splashScreen/page/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

/// --------------------------- ENUMS ---------------------------
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
  editProfile,
  privacyPolicy,
  about,
  chat,
  familyDetails,
  notification,
}

enum ProfileMode {
  viewOther, // viewing someone's profile → Show Interest
  incomingRequest, // user received a request → Accept/Reject
  outgoingRequest, // user sent a request → Accept/Reject
}

enum ProfileType { pro, normal }

/// --------------------------- SERVICES ---------------------------
final LocalDbService localDb = LocalDbService();
final RequestPermission permission = RequestPermission();
final TokenServices token = TokenServices();

/// --------------------------- LOGGER ---------------------------
final logger = Logger(
  printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, printTime: false),
);

/// --------------------------- NAVIGATION KEYS ---------------------------
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get appContext => navigatorKey.currentState!.context;

final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// --------------------------- GO ROUTER ---------------------------
final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  // initialLocation: "/register/normal/profilesetup/normal",
  routes: [
    // Splash
    GoRoute(
      path: "/",
      name: Routes.splash.name,
      builder: (context, state) => BlocProvider(
        create: (context) => MasterBloc()..add(GetprofileStatus()),
        child: SplashScreen(),
      ),
    ),

    // Onboarding & Welcome
    GoRoute(
      path: "/onboard",
      name: Routes.onboard.name,
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: "/firstwelcome",
      name: Routes.welcome.name,
      builder: (context, state) => FirstWelcomeScreen(),
    ),

    // Auth
    GoRoute(
      path: "/signin",
      name: Routes.signin.name,
      builder: (context, state) => SigninScreen(),
      routes: [
        GoRoute(
          path: "otp/:number/:prev",
          name: Routes.otp.name,
          builder: (context, state) => OtpVerificationScreen(
            number: state.pathParameters['number'] ?? "",
            prev: state.pathParameters['prev'] ?? "",
          ),
        ),
        GoRoute(
          path: "signup",
          name: Routes.signup.name,
          builder: (context, state) => SignupScreen(),
        ),
      ],
    ),

    // HomeAnimation
    GoRoute(
      path: "/homeanimation",
      name: Routes.homeAnimationScreen.name,
      builder: (context, state) => HomeAnimationScreen(),
    ),

    // Shell Route with Navbar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // hide navbar on specific paths
        final hideNavbarForPaths = [
          "/homescreen/profileDetail",
          "/homescreen/profileDetail/messageRequested",
          "/homescreen/notification",
          "/homescreen/choosePlan",
          "/homescreen/myProfile",
          "/homescreen/myProfile/editProfile",
          "/chatList/chat",
        ];

        final currentPath = state.uri.toString();
        final showNavbar = !hideNavbarForPaths.any(
          (path) => currentPath.startsWith(path),
        );

        return showNavbar ? Navbar(child: child) : child;
      },
      routes: [
        GoRoute(
          path: "/homescreen",
          name: Routes.homescreen.name,
          builder: (context, state) => BlocProvider(
            create: (context) => HomeBloc(),
            child: HomeScreen(),
          ),
          routes: [
            GoRoute(
              path: "myProfile",
              name: Routes.myProfile.name,
              builder: (context, state) => BlocProvider(
                create: (context) => ProfileSetupBloc(),
                child: MyProfileScreen(),
              ),
              routes: [
                GoRoute(
                  path: "editProfile",
                  name: Routes.editProfile.name,
                  builder: (context, state) => BlocProvider(
                    create: (context) => ProfileSetupBloc(),
                    child: EditProfileScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: "notification",
              name: Routes.notification.name,
              builder: (context, state) => NotificationsScreen(),
            ),
            GoRoute(
              path: "profileDetail/:mode/:id/:match",
              name: Routes.profileDetail.name,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => ProfileDetailBloc()),
                  BlocProvider(create: (context) => HomeBloc()),
                ],
                child: ProfileDetailedScreen(
                  match: state.pathParameters['match'] ?? "50",
                  id: state.pathParameters['id'] ?? "1",
                  mode: state.pathParameters['mode'] ?? "viewOther",
                ),
              ),
              routes: [
                GoRoute(
                  path: "messageRequested",
                  name: Routes.messageRequested.name,
                  builder: (context, state) => MessageRequestedScreen(),
                ),
              ],
            ),
            GoRoute(
              path: "choosePlan",
              name: Routes.choosePlan.name,
              builder: (context, state) => BlocProvider(
                create: (context) => SubscriptionBloc(),
                child: ChooseYourPlanScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: "/discover",
          name: Routes.discover.name,
          builder: (context, state) => BlocProvider(
            create: (context) => DiscoverBloc(),
            child: DiscoverScreen(),
          ),
        ),
        GoRoute(
          path: "/chatList",
          name: Routes.chatList.name,
          builder: (context, state) => ChatListScreen(),
          routes: [
            GoRoute(
              path: "chat",
              name: Routes.chat.name,
              builder: (context, state) => ChatScreen(),
            ),
          ],
        ),
        GoRoute(
          path: "/request",
          name: Routes.request.name,
          builder: (context, state) => BlocProvider(
            create: (context) => RequestBloc(),
            child: RequestScreen(),
          ),
        ),
      ],
    ),

    // Other screens outside ShellRoute
    GoRoute(
      path: "/register/:type",
      name: Routes.register.name,
      builder: (context, state) =>
          RegistrationScreen(type: state.pathParameters["type"] ?? "normal"),
      routes: [
        GoRoute(
          path: "profilesetup/:type1",
          name: Routes.profilesetup.name,
          builder: (context, state) => ProfileSetupScreen(
            type: state.pathParameters["type1"] ?? "normal",
          ),
          routes: [
            GoRoute(
              path: "familyDetails",
              name: Routes.familyDetails.name,
              builder: (context, state) => FamilyDetailsScreen(),
              routes: [
                GoRoute(
                  path: "compatablity1",
                  name: Routes.compatablity1.name,
                  builder: (context, state) => BlocProvider(
                    create: (_) => UserPreferencesBloc(),
                    child: BasicCompablityScreen1(),
                  ),
                  routes: [
                    GoRoute(
                      path: "compatablity2",
                      name: Routes.compatablity2.name,
                      builder: (context, state) => BlocProvider(
                        create: (_) => UserPreferencesBloc(),
                        child: BasicCompablityScreen2(),
                      ),
                      routes: [
                        GoRoute(
                          path: "docVerification",
                          name: Routes.docVerification.name,
                          builder: (context, state) =>
                              DocumentVerificationScreen(),
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
      path: "/privacyPolicy",
      name: Routes.privacyPolicy.name,
      builder: (context, state) => PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: "/about",
      name: Routes.about.name,
      builder: (context, state) => AboutScreen(),
    ),
  ],
);
