import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PasswordVisibilityState extends Equatable {
  bool isVisible;
  PasswordVisibilityState({this.isVisible = true});

  PasswordVisibilityState copyWith({bool? isSwitch, double? slider}) {
    return PasswordVisibilityState(isVisible: isSwitch ?? this.isVisible);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isVisible];
}
