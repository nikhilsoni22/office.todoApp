part of 'obscure_text_bloc.dart';

class ObscureTextState extends Equatable {
  final bool obscure;
  ObscureTextState({
    this.obscure = true,
  });

  ObscureTextState copyWith({bool? obscure}){
    return ObscureTextState(
      obscure: obscure ?? this.obscure,
    );
}

  @override
  List<Object?> get props => [obscure];
}