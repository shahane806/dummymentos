import 'package:equatable/equatable.dart';

abstract class PasswordEvent extends Equatable {}

// ignore: must_be_immutable
class PasswordProtectorEvent extends PasswordEvent {
  bool? ispassprotect;
  PasswordProtectorEvent({required this.ispassprotect});

  @override
  List<Object?> get props => [ispassprotect];
}
