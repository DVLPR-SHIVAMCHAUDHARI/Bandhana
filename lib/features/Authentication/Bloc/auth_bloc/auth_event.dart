import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class SignUpEvent extends AuthEvent {
  final String name;
  final String phone;

  SignUpEvent({required this.name, required this.phone});
  @override
  List<Object?> get props => [name, phone];
}

class SignInEvent extends AuthEvent {
  final String phone;

  SignInEvent({required this.phone});
  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final String phone;

  VerifyOtpEvent({required this.otp, required this.phone});
  @override
  List<Object?> get props => [otp, phone];
}

class ResendOtpEvent extends AuthEvent {
  final String phone;

  ResendOtpEvent({required this.phone});
  @override
  List<Object?> get props => [phone];
}
