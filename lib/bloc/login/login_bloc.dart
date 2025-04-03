import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scanningapp/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/login_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginrepo = LoginRepo();
  LoginBloc() : super(LoginInitial()) {
    on<LoginUserEvent>(loginUserEvent);
  }

  FutureOr<void> loginUserEvent(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      final value = await loginrepo.authentication(event.email, event.password);
      emit(LoginSuccessState(loginModel: value));

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('email', event.email);
      print("Stored email: ${pref.getString("email") ?? 'No email found'}");
    } catch (e) {
      emit(LoginFailureState());
      print("Login failed: $e");
    }
  }
}
