import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_event.dart';

part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? subscription;
  bool show = false;

/*
  void checkInternet(){
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        add(ConnectedEvent());
      } else {
        add(NotConnectedEvent());
      }
    });
  }
*/

  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(ConnectedState(message: 'Connected'));
      }
      if (event is NotConnectedEvent) {
        show = true;
        emit(NotConnectedState(message: 'Not Connected'));
      }
      /*if (event is checkInternetEvent){
        checkInternet();
        emit(checkInternetState());
      }*/
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        add(ConnectedEvent());
      }
      else {
        add(NotConnectedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    subscription!.cancel();
    return super.close();
  }
}
