import 'package:bloc/bloc.dart';
import 'package:chat_app/bloc/bottom_nav_bar/bottom_nav_bar_state.dart';
import 'package:chat_app/bloc/favorites/favorites_bloc.dart';
import 'package:chat_app/bloc/home_screen/home_bloc.dart';
import 'package:chat_app/bloc/priavte_profile/private_profile_bloc.dart';
import 'package:chat_app/bloc/search_people/search_bloc.dart';
import 'package:chat_app/ui/screens/add.dart';
import 'package:chat_app/ui/screens/favorites.dart';
import 'package:chat_app/ui/screens/home.dart';
import 'package:chat_app/ui/screens/private_profile.dart';
import 'package:chat_app/ui/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';


class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial());

  static BottomNavBarCubit get(context) => BlocProvider.of(context);

  int index = 0;


  List<Widget> bottomItems = [
    Icon(Icons.home, size: 35,),
    Icon(Icons.search, size: 35,),
    Icon(Icons.add, size: 35,),
    Icon(Icons.favorite, size: 35,),
    Icon(Icons.person, size: 35,),
  ];

  List<Widget> screens = [
     HomeScreen(),
     SearchScreen(),
     AddScreen(),
     FavoritesScreen(),
     PrivateProfile(),
  ];

  void changeBottomNavBar(int indexx,context) {
    index = indexx;
    if(index==0){
      BlocProvider.of<HomeBloc>(context).add(GetPostsHomeEvent());
    }
    else if(index == 1){
      BlocProvider.of<SearchBloc>(context).searchResult.clear();
    }
    else if(index == 3){
      BlocProvider.of<FavoritesBloc>(context).add(GetFavoritesPostsEvent());
    }
    else if(index == 4){
      BlocProvider.of<PrivateProfileBloc>(context).add(DownloadPrivateProfileEvent());
    }
    emit(ChangeBottomNavState());
  }

}