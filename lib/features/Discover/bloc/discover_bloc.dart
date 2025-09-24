import 'dart:developer';

import 'package:bandhana/features/Discover/bloc/discover_event.dart';
import 'package:bandhana/features/Discover/bloc/discover_state.dart';
import 'package:bandhana/features/Discover/repository/discover_repository.dart';
import 'package:bandhana/features/Home/models/home_user_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverRepository repo = DiscoverRepository();
  DiscoverBloc() : super(InitialState()) {
    on<FetchUsersEvent>(fetchUsers);
  }

  Future<void> fetchUsers(
    FetchUsersEvent event,
    Emitter<DiscoverState> emit,
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
