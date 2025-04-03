import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PasswordProtectorState extends Equatable {
  bool ispassprotected;

  PasswordProtectorState({this.ispassprotected = false});

  PasswordProtectorState copyWith({bool? ispassprot}) {
    return PasswordProtectorState(
        ispassprotected: ispassprot ?? this.ispassprotected);
  }

  @override
  List<Object?> get props => [ispassprotected];
}
