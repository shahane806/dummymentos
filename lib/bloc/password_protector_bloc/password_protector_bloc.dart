import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/bloc/password_protector_bloc/password_protector_event.dart';
import 'package:scanningapp/bloc/password_protector_bloc/password_protector_state.dart';

class PasswordProtectorBloc
    extends Bloc<PasswordEvent, PasswordProtectorState> {
  PasswordProtectorBloc() : super(PasswordProtectorState()) {
    on<PasswordProtectorEvent>(passwordProtectorEvent);
  }

  void passwordProtectorEvent(
      PasswordProtectorEvent event, Emitter<PasswordProtectorState> emit) {
    emit(state.copyWith(ispassprot: event.ispassprotect));
  }
}
