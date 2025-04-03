part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

// ignore: must_be_immutable
final class LoginSuccessState extends LoginState {
  LoginModel loginModel;
  LoginSuccessState({this.loginModel = const LoginModel()});
}

final class LoginFailureState extends LoginState {}
