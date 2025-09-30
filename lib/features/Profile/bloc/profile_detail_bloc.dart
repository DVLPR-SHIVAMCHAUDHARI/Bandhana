// In 'profile_detail_bloc.dart'

import 'package:bandhana/features/Profile/bloc/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc/profile_detail_state.dart';
import 'package:bandhana/features/Profile/model/user_detail_model.dart';
import 'package:bandhana/features/Profile/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  UserDetailModel? _currentUser;

  final int centerIndex = 3;
  final ProfileRepository repo = ProfileRepository();

  bool _isFavorite = false;

  ProfileDetailBloc() : super(InitialState()) {
    on<GetUserDetailById>(_onGetUserDetailById);
    on<SwitchImageEvent>(_switchImage);
    on<ToggleFavoriteEvent>(_toggleFavorite);
    on<SendRequestEvent>(sendRequest);
    on<AcceptRequestEvent>(acceptRequest);
  }

  Future<void> _onGetUserDetailById(
    GetUserDetailById event,
    Emitter<ProfileDetailState> emit,
  ) async {
    emit(ProfileDetailLoading());
    try {
      final result = await repo.getUserById(id: event.id);

      if (result["status"] == "Success") {
        final UserDetailModel user = result["response"] as UserDetailModel;
        _currentUser = user;

        emit(ProfileDetailLoaded(user, isFavorite: _isFavorite));
      } else {
        emit(
          ProfileDetailError(result["response"]?.toString() ?? "Unknown error"),
        );
      }
    } catch (e) {
      emit(ProfileDetailError(e.toString()));
    }
  }

  void _switchImage(SwitchImageEvent event, Emitter<ProfileDetailState> emit) {
    if (_currentUser == null) return;

    final newAvatars = event.avatars
        .map((avatar) => Map<String, dynamic>.from(avatar))
        .toList();

    if (event.selectedIndex != centerIndex) {
      final temp = newAvatars[centerIndex]['url'];
      newAvatars[centerIndex]['url'] = newAvatars[event.selectedIndex]['url'];
      newAvatars[event.selectedIndex]['url'] = temp;
    }

    emit(SwitchImageState(newAvatars, centerIndex, _currentUser!, _isFavorite));
  }

  void _toggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ProfileDetailState> emit,
  ) {
    if (_currentUser == null) return;

    _isFavorite = !_isFavorite;

    emit(FavoriteToggledState(_isFavorite, _currentUser!));
  }

  sendRequest(SendRequestEvent event, Emitter emit) async {
    emit(SendRequestLoadingState());
    try {
      final result = await repo.sendRequest(id: event.id);

      if (result["status"] == "Success") {
        emit(SendRequestLoadedState(result["response"]));
      } else {
        emit(
          SendRequestErrorState(
            result["response"]?.toString() ?? "Unknown error",
          ),
        );
      }
    } catch (e) {
      emit(SendRequestErrorState(e.toString()));
    }
  }

  // --- Accept Request ---
  acceptRequest(AcceptRequestEvent event, Emitter emit) async {
    emit(AcceptRequestLoadingState());
    try {
      final result = await repo.acceptRequest(id: event.id);

      if (result["status"] == "Success") {
        // Correct path
        final displayText =
            result["Response"]?["Status"]?["DisplayText"] ?? "Success";
        emit(AcceptRequestLoadedState(displayText));
      } else {
        emit(
          AcceptRequestErrorState(
            result["Response"]?.toString() ?? "Unknown error",
          ),
        );
      }
    } catch (e) {
      emit(AcceptRequestErrorState(e.toString()));
    }
  }
}
