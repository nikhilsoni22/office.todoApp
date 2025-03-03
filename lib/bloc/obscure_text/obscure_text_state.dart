part of 'obscure_text_bloc.dart';

class ObscureTextState extends Equatable {
  final bool obscure;
  final bool obscureLogin;
  ObscureTextState({
    this.obscure = true,
    this.obscureLogin = true,
  });

  ObscureTextState copyWith({bool? obscure, bool? obscureLogin}){
    return ObscureTextState(
      obscure: obscure ?? this.obscure,
      obscureLogin: obscureLogin ?? this.obscureLogin,
    );
}

  @override
  List<Object?> get props => [obscure, obscureLogin];
}