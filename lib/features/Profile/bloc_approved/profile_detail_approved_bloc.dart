// In 'profile_detail_approved_bloc.dart'

import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_event.dart';
import 'package:MilanMandap/features/Profile/bloc_approved/profile_detail_approved_state.dart';
import 'package:MilanMandap/features/Profile/model/user_detail_model.dart';
import 'package:MilanMandap/features/Profile/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailApprovedBloc
    extends Bloc<ProfileDetailApprovedEvent, ProfileDetailApprovedState> {
  UserDetailModel? _currentUser;

  final int centerIndex = 3;
  final ProfileRepository repo = ProfileRepository();

  bool _isFavorite = false;

  ProfileDetailApprovedBloc() : super(InitialState()) {
    on<GetUserDetailById>(_onGetUserDetailById);
    on<SwitchImageEvent>(_switchImage);
    on<ToggleFavoriteEvent>(_toggleFavorite);
    on<SendRequestEvent>(sendRequest);
    on<AcceptRequestEvent>(acceptRequest);
  }

  Future<void> _onGetUserDetailById(
    GetUserDetailById event,
    Emitter<ProfileDetailApprovedState> emit,
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

  void _switchImage(
    SwitchImageEvent event,
    Emitter<ProfileDetailApprovedState> emit,
  ) {
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
    Emitter<ProfileDetailApprovedState> emit,
  ) {
    if (_currentUser == null) return;

    _isFavorite = !_isFavorite;

    emit(FavoriteToggledState(_isFavorite, _currentUser!));
  }

  sendRequest(
    SendRequestEvent event,
    Emitter<ProfileDetailApprovedState> emit,
  ) async {
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
  acceptRequest(
    AcceptRequestEvent event,
    Emitter<ProfileDetailApprovedState> emit,
  ) async {
    emit(AcceptRequestLoadingState());
    try {
      final result = await repo.acceptRequest(id: event.id);

      if (result["status"] == "Success") {
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
