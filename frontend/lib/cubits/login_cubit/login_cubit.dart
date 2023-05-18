import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(UnLoggedState());

  void setUnLoggedState(BuildContext context){
    Navigator.of(context).popUntil((route) => route.isFirst);
    UserStore().clearUser();
    SharedPreferences.getInstance().then((pref){
      pref.clear();
    });
    emit(UnLoggedState());
  }

  void setLoggedState(BuildContext context){
    Navigator.of(context).popUntil((route) => route.isFirst);
    emit(LoggedState());
  }

}
