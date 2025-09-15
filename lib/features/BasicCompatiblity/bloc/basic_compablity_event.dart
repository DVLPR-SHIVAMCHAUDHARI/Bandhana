// lib/core/bloc/user_preferences/user_preferences_event.dart
import 'package:equatable/equatable.dart';

abstract class UserPreferencesEvent extends Equatable {
  const UserPreferencesEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPreferencesEvent extends UserPreferencesEvent {
  final Map<String, dynamic> preferences;
  const SubmitPreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

class SubmitLifestylePreferencesEvent extends UserPreferencesEvent {
  final Map<String, dynamic> preferences;
  const SubmitLifestylePreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
