// lib/core/bloc/user_preferences/user_preferences_state.dart
import 'package:equatable/equatable.dart';

abstract class UserPreferencesState extends Equatable {
  const UserPreferencesState();

  @override
  List<Object?> get props => [];
}

class PreferencesInitial extends UserPreferencesState {}

class PreferencesLoading extends UserPreferencesState {}

class PreferencesSuccess extends UserPreferencesState {
  final String message;
  const PreferencesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PreferencesFailure extends UserPreferencesState {
  final String message;
  const PreferencesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LifestylePreferencesLoading extends UserPreferencesState {}

class LifestylePreferencesSuccess extends UserPreferencesState {
  final String message;
  const LifestylePreferencesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LifestylePreferencesFailure extends UserPreferencesState {
  final String message;
  const LifestylePreferencesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
