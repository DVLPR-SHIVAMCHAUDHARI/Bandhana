import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Profile/bloc_normal/profile_detail_event.dart';
import 'package:bandhana/features/Profile/bloc_normal/profile_detail_state.dart';
import 'package:bandhana/features/Profile/repository/profile_repository.dart';
import 'package:bandhana/features/master_apis/repository/master_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  HomeUserModel? _currentUser;
  final int centerIndex = 3; // Default center avatar
  bool _isFavorite = false;

  final ProfileRepository repo = ProfileRepository();
  final MasterRepo masterRepo = MasterRepo();

  ProfileDetailBloc() : super(InitialState()) {
    on<SwitchImageEvent>(_switchImage);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SendRequestEvent>(_sendRequest);
    on<AcceptRequestEvent>(_acceptRequest);
  }

  /// Set current user before switching images or toggling favorite
  void setCurrentUser(user) {
    _currentUser = user;
    emit(ProfileDetailLoaded(user, isFavorite: _isFavorite));
  }

  /// --- Image Switching ---
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

  /// --- Toggle Favorite ---

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ProfileDetailState> emit,
  ) async {
    emit(ToggleFavoriteLoading());
    try {
      final isAdded = await masterRepo.toggleFavorite(
        event.userId,
        add: event.add,
      );
      emit(ToggleFavoriteSuccess(userId: event.userId, isFavorite: isAdded));
    } catch (e) {
      emit(ToggleFavoriteError(e.toString()));
    }
  }

  /// --- Send Request (unchanged) ---
  void _sendRequest(
    SendRequestEvent event,
    Emitter<ProfileDetailState> emit,
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

  /// --- Accept Request (unchanged) ---
  void _acceptRequest(
    AcceptRequestEvent event,
    Emitter<ProfileDetailState> emit,
  ) async {
    emit(AcceptRequestLoadingState());
    try {
      final result = await repo.acceptRequest(id: event.id);
      if (result["status"] == "Success") {
        emit(AcceptRequestLoadedState(result["response"]["DisplayText"]));
      } else {
        emit(
          AcceptRequestErrorState(
            result["response"]?.toString() ?? "Unknown error",
          ),
        );
      }
    } catch (e) {
      emit(AcceptRequestErrorState(e.toString()));
    }
  }
}
