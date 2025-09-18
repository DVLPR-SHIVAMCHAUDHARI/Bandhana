import 'dart:developer';

import 'package:bandhana/features/Home/bloc/home_event.dart';
import 'package:bandhana/features/Home/bloc/home_state.dart';
import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repo = HomeRepository();
  HomeBloc() : super(InitialState()) {
    on<FetchUsersEvent>(fetchUsers);
  }

  Future<void> fetchUsers(
    FetchUsersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(FetchUsersLoadingState());
    try {
      final response = await repo.getUserList();

      if (response["status"] == "Success") {
        final List<HomeUserModel> users = response["response"];
        log("🎯 Emitting Loaded with ${users.length} users");
        emit(FetchUserLoadedState(users));
      } else {
        emit(FetchUserFailureState(response["response"].toString()));
      }
    } catch (e, st) {
      log("❌ Error in fetchUsers: $e", stackTrace: st);
      emit(FetchUserFailureState(e.toString()));
    }
  }
}
