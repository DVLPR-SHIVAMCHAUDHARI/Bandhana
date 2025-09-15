// lib/core/bloc/user_preferences/user_preferences_bloc.dart
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_event.dart';
import 'package:bandhana/features/BasicCompatiblity/bloc/basic_compablity_state.dart';
import 'package:bandhana/features/BasicCompatiblity/repositories/basic_compatiblity_repository.dart';
import 'package:bloc/bloc.dart';

class UserPreferencesBloc
    extends Bloc<UserPreferencesEvent, UserPreferencesState> {
  final UserPreferencesRepository repository = UserPreferencesRepository();

  UserPreferencesBloc() : super(PreferencesInitial()) {
    on<SubmitPreferencesEvent>(_onSubmitPreferences);
    on<SubmitLifestylePreferencesEvent>(_onSubmitLifestylePreferences);
  }

  Future<void> _onSubmitPreferences(
    SubmitPreferencesEvent event,
    Emitter<UserPreferencesState> emit,
  ) async {
    emit(PreferencesLoading());
    try {
      final response = await repository.submitPreferences(event.preferences);

      if (response['status'] == 'success') {
        emit(PreferencesSuccess(response['message']));
      } else {
        emit(PreferencesFailure(response['message']));
      }
    } catch (e) {
      emit(PreferencesFailure(e.toString()));
    }
  }

  Future<void> _onSubmitLifestylePreferences(
    SubmitLifestylePreferencesEvent event,
    Emitter<UserPreferencesState> emit,
  ) async {
    emit(LifestylePreferencesLoading());
    try {
      final response = await repository.submitLifestylePreferences(
        event.preferences,
      );

      if (response['status'] == 'success') {
        emit(LifestylePreferencesSuccess(response['message']));
      } else {
        emit(LifestylePreferencesFailure(response['message']));
      }
    } catch (e) {
      emit(LifestylePreferencesFailure(e.toString()));
    }
  }
}
