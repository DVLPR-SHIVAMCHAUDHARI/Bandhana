// In 'profile_detail_approved_state.dart'

import 'package:MilanMandap/features/Profile/model/user_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileDetailApprovedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ProfileDetailApprovedState {
  @override
  List<Object?> get props => [];
}

class GetProfileDetailState extends ProfileDetailApprovedState {}

class ProfileDetailLoading extends GetProfileDetailState {}

// 🔹 Main Loaded state with user data - NOW INCLUDES isFavorite
class ProfileDetailLoaded extends GetProfileDetailState {
  final UserDetailModel user;
  final bool isFavorite; // 👈 CRITICAL: Added isFavorite status

  ProfileDetailLoaded(this.user, {this.isFavorite = false}); // Default to false

  @override
  List<Object?> get props => [user, isFavorite];
}

// 🔹 Image Switching state - CARRIES USER DATA
class SwitchImageState extends ProfileDetailApprovedState {
  final List<Map<String, dynamic>> avatars;
  final int selectedIndex;
  final UserDetailModel user;
  final bool isFavorite; // 👈 CRITICAL: Added isFavorite status

  SwitchImageState(
    this.avatars,
    this.selectedIndex,
    this.user,
    this.isFavorite,
  );

  @override
  List<Object?> get props => [avatars, selectedIndex, user, isFavorite];
}

// 🔹 Favorite Toggled state - CARRIES USER DATA
class FavoriteToggledState extends ProfileDetailApprovedState {
  final bool isFavorite;
  final UserDetailModel user;

  FavoriteToggledState(this.isFavorite, this.user);

  @override
  List<Object?> get props => [isFavorite, user];
}

// 🔹 Error state
class ProfileDetailError extends GetProfileDetailState {
  final String message;

  ProfileDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class SendRequestLoadingState extends ProfileDetailApprovedState {}

class SendRequestLoadedState extends ProfileDetailApprovedState {
  final String message;

  SendRequestLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

// 🔹 Error state
class SendRequestErrorState extends GetProfileDetailState {
  final String message;

  SendRequestErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Accept Request States ---
class AcceptRequestLoadingState extends ProfileDetailApprovedState {}

class AcceptRequestLoadedState extends ProfileDetailApprovedState {
  final String message;

  AcceptRequestLoadedState(this.message);

  @override
  List<Object?> get props => [message];
}

class AcceptRequestErrorState extends ProfileDetailApprovedState {
  final String message;

  AcceptRequestErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
