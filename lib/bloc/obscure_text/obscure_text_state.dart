part of 'obscure_text_bloc.dart';

class ObscureTextState extends Equatable {
  final bool obscure;
  final bool obscureLogin;
  final bool confirmBtn;
  ObscureTextState({
    this.obscure = true,
    this.obscureLogin = true,
    this.confirmBtn = true,
  });

  ObscureTextState copyWith({bool? obscure, bool? obscureLogin, bool? confirmBtn}){
    return ObscureTextState(
      obscure: obscure ?? this.obscure,
      obscureLogin: obscureLogin ?? this.obscureLogin,
      confirmBtn: confirmBtn ?? this.confirmBtn,
    );
}

  @override
  List<Object?> get props => [obscure, obscureLogin, confirmBtn];
}