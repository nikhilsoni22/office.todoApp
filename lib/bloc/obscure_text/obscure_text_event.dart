part of 'obscure_text_bloc.dart';

abstract class ObscureTextEvents extends Equatable {
  ObscureTextEvents();

  @override
  List<Object?> get props => [];
}

class EnableOrDisableObscureTextEvent extends ObscureTextEvents {}