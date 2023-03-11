import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/bloc/bottom_nav_bar/bottom_nav_bar_cubit.dart';
import 'package:chat_app/bloc/chat/chat_bloc.dart';
import 'package:chat_app/bloc/comments/comments_bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/ui/screens/comments.dart';
import 'package:chat_app/ui/screens/control_pages.dart';
import 'package:chat_app/ui/screens/edit_profile.dart';
import 'package:chat_app/ui/screens/login.dart';
import 'package:chat_app/ui/screens/notification.dart';
import 'package:chat_app/ui/screens/private_chat.dart';
import 'package:chat_app/ui/screens/public_chats.dart';
import 'package:chat_app/ui/screens/register.dart';
import 'package:chat_app/ui/screens/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/init':
        return MaterialPageRoute(
            builder: (_) => startwidget == LoginScreen()
                ? BlocProvider.value(
                    value: AuthBloc(),
                    child: startwidget!,
                  )
                : startwidget == const ControlPages()
                    ? BlocProvider.value(
                        value: BottomNavBarCubit(),
                        child: startwidget!,
                      )
                    : startwidget!);
        break;
      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: AuthBloc(),
            child: LoginScreen(),
          ),
        );
        break;
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );
        break;
      case '/reset_password':
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(),
        );
        break;
      case '/home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: BottomNavBarCubit(),
                  child: const ControlPages(),
                ));
        break;
      case '/comments':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: CommentsBloc(),
              child: Comments(),
            )
        );
        break;
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) =>  Edit_Profile());
        break;
      case '/notif':
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
        break;
      case '/public_chats':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: ChatBloc(),
              child: Public_Chats(),
            )
        );
        break;
      case '/private_chat':
        return MaterialPageRoute(builder: (_) =>  Private_Chat());
        break;
      default:
        return null;
    }
  }
}
