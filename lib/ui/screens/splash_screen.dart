import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashViewbodyState();
}

class _SplashViewbodyState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();
    //initSlidingAnimation();

    //navigateToHome();
  }

  @override
  void dispose() {
    super.dispose();

    //animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      //splash: 'assets/images/Comp-1.gif',
      splash: 'assets/images/brand.png',
      animationDuration: Duration(seconds: 1),
      splashIconSize: 600,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: introColor,
      screenRouteFunction: () async {
        return '/init';
      },


      //SlidingText(slidingAnimation: slidingAnimation),
    );
  }

  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // Get.to(() => const HomeView(),
        //     // calculations
        //     transition: Transition.fade,
        //     duration: kTranstionDuration);

        //GoRouter.of(context).push(AppRouter.kHomeView);
      },
    );
  }
}
