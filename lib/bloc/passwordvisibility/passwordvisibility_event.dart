import 'package:equatable/equatable.dart';

abstract class PasswordVisibilityEvent extends Equatable {
  PasswordVisibilityEvent();
  @override
  List<Object> get props => [];
}

class EnabledOrDisablePassword extends PasswordVisibilityEvent {}


