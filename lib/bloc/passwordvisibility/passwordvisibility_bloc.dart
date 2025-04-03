import 'package:bloc/bloc.dart';

import 'passwordvisibility_event.dart';
import 'passwordvisibility_state.dart';


class PasswordVisibilityBloc
    extends Bloc<PasswordVisibilityEvent, PasswordVisibilityState> {
  PasswordVisibilityBloc() : super(PasswordVisibilityState()) {
    on<EnabledOrDisablePassword>(_enableOrDisabledEvents);
  }

  void _enableOrDisabledEvents(
      EnabledOrDisablePassword events, Emitter<PasswordVisibilityState> emit) {
    emit(state.copyWith(isSwitch: !state.isVisible));
  }
}
