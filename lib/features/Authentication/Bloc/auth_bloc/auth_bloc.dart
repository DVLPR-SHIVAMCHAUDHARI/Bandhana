import 'dart:developer';

import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_event.dart';
import 'package:MilanMandap/features/Authentication/Bloc/auth_bloc/auth_state.dart';
import 'package:MilanMandap/features/Authentication/Repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository repo = AuthRepository();
  AuthBloc() : super(InitialState()) {
    on<SignUpEvent>(signUp);
    on<SignInEvent>(signIn);
    on<VerifyOtpEvent>(verifyOtp);
    on<ResendOtpEvent>(reSendOtp);
  }

  signUp(SignUpEvent event, Emitter emit) async {
    emit(SignUpLoadingState());
    try {
      var response = await repo.signUp(name: event.name, number: event.phone);
      if (response["status"] == "success") {
        emit(SignUpLoadedState(response["message"]));
      } else {
        logger.e(response["status"]);
        emit(SignUpErrorState(response['message']));
      }
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }

  signIn(SignInEvent event, Emitter emit) async {
    emit(SignInLoadingState());
    try {
      var response = await repo.signIn(number: event.phone);
      if (response["status"] == "success") {
        log("signin");
        emit(SignInLoadedState(response["message"]));
      } else {
        logger.e(response["status"]);
        emit(SignInErrorState(response['message']));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }

  verifyOtp(VerifyOtpEvent event, Emitter emit) async {
    emit(VerifyOtpLoadingState());
    try {
      var response = await repo.verifyOtp(number: event.phone, otp: event.otp);
      if (response["status"] == "success") {
        emit(VerifyOtpLoadedState(response["message"]!));
      } else {
        emit(VerifyOtpErrorState(response['message']));
      }
    } catch (e) {
      emit(VerifyOtpErrorState(e));
    }
  }

  reSendOtp(ResendOtpEvent event, Emitter emit) async {
    emit(ResendOtpLoadingState());
    try {
      var response = await repo.reSendOtp(number: event.phone);
      if (response["status"] == "success") {
        emit(ResendOtpLoadedState(response["message"]));
      } else {
        emit(ResendOtpErrorState(response['message']));
      }
    } catch (e) {
      emit(ResendOtpErrorState(e));
    }
  }
}
