import 'package:bandhana/features/Home/models/home_user_model.dart';
import 'package:bandhana/features/Profile/model/user_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

// 🔹 Initial State
class InitialState extends ProfileDetailState {}

// 🔹 State while fetching profile (if needed)
class GetProfileDetailState extends ProfileDetailState {}

class ProfileDetailLoading extends GetProfileDetailState {}

// 🔹 Loaded state with user info & favorite status
class ProfileDetailLoaded extends GetProfileDetailState {
  final HomeUserModel
  user; // Using HomeUserModel since detail comes from HomeBloc
  final bool isFavorite;

  ProfileDetailLoaded(this.user, {this.isFavorite = false});

  @override
  List<Object?> get props => [user, isFavorite];
}

// 🔹 Image switching state
class SwitchImageState extends ProfileDetailState {
  final List<Map<String, dynamic>> avatars;
  final int selectedIndex;
  final HomeUserModel user;
  final bool isFavorite;

  SwitchImageState(
    this.avatars,
    this.selectedIndex,
    this.user,
    this.isFavorite,
  );
}

// 🔹 Favorite toggled state

class ToggleFavoriteLoading extends ProfileDetailState {}

class ToggleFavoriteSuccess extends ProfileDetailState {
  final String userId;
  final bool isFavorite;

  ToggleFavoriteSuccess({required this.userId, required this.isFavorite});
}

class ToggleFavoriteError extends ProfileDetailState {
  final String message;

  ToggleFavoriteError(this.message);
}

// 🔹 Error and request states (unchanged from your original)
class ProfileDetailError extends GetProfileDetailState {
  final String message;
  ProfileDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class SendRequestLoadingState extends ProfileDetailState {}

class SendRequestLoadedState extends ProfileDetailState {
  final String message;
  SendRequestLoadedState(this.message);
  @override
  List<Object?> get props => [message];
}

class SendRequestErrorState extends GetProfileDetailState {
  final String message;
  SendRequestErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class AcceptRequestLoadingState extends ProfileDetailState {}

class AcceptRequestLoadedState extends ProfileDetailState {
  final String message;
  AcceptRequestLoadedState(this.message);
  @override
  List<Object?> get props => [message];
}

class AcceptRequestErrorState extends ProfileDetailState {
  final String message;
  AcceptRequestErrorState(this.message);
  @override
  List<Object?> get props => [message];
}
