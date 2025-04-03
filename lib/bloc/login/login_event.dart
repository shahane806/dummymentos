part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class LoginUserEvent extends LoginEvent {
  String email;
  String password;

  LoginUserEvent({required this.email, required this.password});

}
