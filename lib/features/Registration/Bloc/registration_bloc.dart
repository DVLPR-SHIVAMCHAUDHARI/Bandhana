import 'package:bandhana/features/Registration/repositories/location_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    /// Load initial data
    on<LoadRegistrationData>((event, emit) async {
      emit(RegistrationLoading());
      try {
        final data = locations; // static list for now

        emit(
          RegistrationLoaded(
            countries: data,
            states: [],
            cities: [],
            genders: ["Male", "Female", "Other"],
            hobbiesList: ["Reading", "Sports", "Music", "Traveling"],
          ),
        );
      } catch (e) {
        emit(RegistrationFailure("Failed to load registration data"));
      }
    });

    /// Select Country
    on<SelectCountry>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        final country = current.countries.firstWhere(
          (c) => c['country'] == event.country,
        );

        final states = (country['states'] as List)
            .map<String>((s) => s['state'] as String)
            .toList();

        emit(
          current.copyWith(
            selectedCountry: event.country,
            states: states,
            cities: [],
            selectedState: null,
            selectedCity: null,
          ),
        );
      }
    });

    /// Select State
    on<SelectState>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;

        final country = current.countries.firstWhere(
          (c) => c['country'] == current.selectedCountry,
        );
        final stateMap = (country['states'] as List).firstWhere(
          (s) => s['state'] == event.state,
        );

        final cities = (stateMap['cities'] as List)
            .map<String>((c) => c.toString())
            .toList();

        emit(
          current.copyWith(
            selectedState: event.state,
            cities: cities,
            selectedCity: null,
          ),
        );
      }
    });

    /// Select City
    on<SelectCity>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        emit(current.copyWith(selectedCity: event.city));
      }
    });

    /// Profile fields
    on<UpdateName>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        emit(current.copyWith(name: event.name));
      }
    });

    on<UpdateGender>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        emit(current.copyWith(gender: event.gender));
      }
    });

    on<UpdateDob>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        emit(current.copyWith(dob: event.dob));
      }
    });

    on<UpdateHobbies>((event, emit) {
      if (state is RegistrationLoaded) {
        final current = state as RegistrationLoaded;
        emit(current.copyWith(selectedHobbies: event.hobbies));
      }
    });
  }
}
