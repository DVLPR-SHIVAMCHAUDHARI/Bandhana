import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {}

class InitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignUpLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignUpLoadedState extends AuthState {
  final String message;
  SignUpLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

class SignUpErrorState extends AuthState {
  final String message;
  SignUpErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class SignInLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignInLoadedState extends AuthState {
  final String message;
  SignInLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

class SignInErrorState extends AuthState {
  final String message;
  SignInErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class VerifyOtpLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class VerifyOtpLoadedState extends AuthState {
  final String message;
  VerifyOtpLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

class VerifyOtpErrorState extends AuthState {
  final message;
  VerifyOtpErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class ResendOtpLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class ResendOtpLoadedState extends AuthState {
  final String message;
  ResendOtpLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

class ResendOtpErrorState extends AuthState {
  final message;
  ResendOtpErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
