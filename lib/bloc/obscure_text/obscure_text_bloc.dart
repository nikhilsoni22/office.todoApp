import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'obscure_text_event.dart';
part 'obscure_text_state.dart';

class ObscureTextBloc extends Bloc<ObscureTextEvents, ObscureTextState>{
    ObscureTextBloc() : super(ObscureTextState()){
      on<EnableOrDisableObscureTextEvent>(_enableOrDisableObscureTextEvent);
    }

    void _enableOrDisableObscureTextEvent(EnableOrDisableObscureTextEvent event, Emitter<ObscureTextState> emit){
      emit(state.copyWith(obscure: !state.obscure));
    }
}