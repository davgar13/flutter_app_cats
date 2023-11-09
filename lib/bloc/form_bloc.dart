import 'package:flutter_app_cats/bloc/form_events.dart';
import 'package:flutter_app_cats/bloc/form_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormBloc extends Bloc<FormEvents, FormStates> {
  FormBloc() : super(FormStates()) {
    on<PendingEvent>(onPendingEvent);
    on<SuccessEvent>(onSuccessEvent);
  }
  void onPendingEvent(PendingEvent event, Emitter<FormStates> emit) {
    emit(UpdateState("n"));
  }
  void onSuccessEvent(SuccessEvent event, Emitter<FormStates> emit) {
    emit(UpdateState("y"));
  }
}