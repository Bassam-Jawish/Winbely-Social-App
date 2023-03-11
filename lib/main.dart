import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/BlocObserver.dart';
import 'package:chat_app/bloc/add_post/add_post_bloc.dart';
import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:chat_app/bloc/chat/chat_bloc.dart';
import 'package:chat_app/bloc/comments/comments_bloc.dart';
import 'package:chat_app/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:chat_app/bloc/favorites/favorites_bloc.dart';
import 'package:chat_app/bloc/follow_helper/follow_helper_bloc.dart';
import 'package:chat_app/bloc/home_screen/home_bloc.dart';
import 'package:chat_app/bloc/internet_connection/internet_bloc.dart';
import 'package:chat_app/bloc/priavte_profile/private_profile_bloc.dart';
import 'package:chat_app/bloc/search_people/search_bloc.dart';
import 'package:chat_app/cache/cache_helper.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/routes/app_router.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/screens/control_pages.dart';
import 'package:chat_app/ui/screens/login.dart';
import 'package:chat_app/ui/screens/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await FirebaseMessaging.instance.getInitialMessage();

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });



  await CacheHelper.init();
  token = CacheHelper.getData(key: 'token');
  print('token= $token');
  onBoarding = CacheHelper.getData(key: 'onBoarding');

  if (onBoarding != null) {
    if (token != null) {
      startwidget = const ControlPages();
    } else {
      startwidget = LoginScreen();
    }
  } else {
    startwidget = const OnboardingScreen();
  }

  //AppRouter(startWidget: widget);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthBloc()),
        BlocProvider(create: (BuildContext context) => InternetBloc()),
        BlocProvider(create: (BuildContext context) => BottomNavBarCubit()),
        BlocProvider(create: (BuildContext context) => AddPostBloc()),
        BlocProvider(create: (BuildContext context) => HomeBloc()..add(GetPostsHomeEvent())),
        BlocProvider(create: (BuildContext context) => SearchBloc()),
        BlocProvider(create: (BuildContext context) => FavoritesBloc()..add(GetFavoritesPostsEvent())),
        BlocProvider(create: (BuildContext context) => PrivateProfileBloc()..add(DownloadPrivateProfileEvent())),
        BlocProvider(create: (BuildContext context) => EditProfileBloc()),
        BlocProvider(create: (BuildContext context) => FollowHelperBloc()),
        BlocProvider(create: (BuildContext context) => CommentsBloc()..add(ShowCommentsEvent())),
        BlocProvider(create: (BuildContext context) => ChatBloc()),


      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home:
    AnimatedSplashScreen.withScreenRouteFunction(
          //splash: 'assets/images/Comp-1.gif',
          splash: 'assets/images/brand.png',
          //animationDuration: Duration(seconds: 7),
          splashIconSize: 600,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,

      //backgroundColor: Colors.white,
      backgroundColor: introColor,
          screenRouteFunction: () async {
            return '/init';
          },
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
