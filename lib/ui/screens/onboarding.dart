import 'package:chat_app/cache/cache_helper.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: IntroductionScreen(
        globalBackgroundColor: introColor,
        pages: [
          PageViewModel(
            title: 'Winbely',
            body: 'Welcome to Winbely',
            image: Container(
              width: 1400,
                height: 1400,
                child: Image.asset('assets/images/brand.png')),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Sharing..',
            body: 'Share  your photos & videos with the followers you care about',
            image: Image.asset('assets/images/sharing.png'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Messaging..',
            body: 'Message your friends in Direct',
            image: Image.asset('assets/images/messaging.png'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Exploring..',
            body: 'Search & Explore to Learn More About Your Interests',
            image: Image.asset('assets/images/searching.png'),
            decoration: getPageDecoration(),
          ),
        ],

        curve: Curves.fastLinearToSlowEaseIn,

        next: const Icon(Icons.arrow_forward,color: Colors.white,),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        onDone: () {
          CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
            if (value) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
        },
        showSkipButton: true,
        skip: const Text('Skip',style: TextStyle(color: Colors.white),),
        //onSkip: () => print('skip'),
        // showBackButton: true,
        // back: const Icon(Icons.arrow_back),
        dotsDecorator: getDotDecoration(),
        nextFlex: 0,
        skipOrBackFlex: 0,
        animationDuration: 500,

        isProgressTap: true,
        isProgress: true,
        // freeze: false,
        onChange: (index) => print(index),
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w600,
          fontFamily: 'Pacifico',
          color: Colors.white),
      bodyTextStyle: TextStyle(fontSize: 20, color: Colors.white),
      imagePadding: EdgeInsets.all(24),
      titlePadding: EdgeInsets.zero,
      bodyPadding: EdgeInsets.all(24),
      //pageColor: primaryGradient,
    );
  }

  DotsDecorator getDotDecoration() {
    return DotsDecorator(
        color: backgroundColor,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeColor: Colors.pinkAccent,
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)));
  }
}
