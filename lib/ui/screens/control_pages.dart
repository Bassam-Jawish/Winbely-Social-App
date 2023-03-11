import 'package:chat_app/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:chat_app/bloc/bottom_nav_bar/bottom_nav_bar_state.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ControlPages extends StatelessWidget {
  const ControlPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BottomNavBarCubit.get(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: bottomNavBar,
      ),
    );

    return BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ClipRect(
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: null,
            body: cubit.screens[cubit.index],
            bottomNavigationBar: buildBNB(context, cubit, height),
          ),
        );
      },
    );
  }

  buildBNB(context, cubit, height) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      child: CurvedNavigationBar(
        color: bottomNavBar,
        buttonBackgroundColor: buttonBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        backgroundColor: Colors.transparent,
        items: cubit.bottomItems,
        height: height * 0.07,
        index: cubit.index,
        onTap: (index) => cubit.changeBottomNavBar(index,context),
      ),
    );
  }
}
