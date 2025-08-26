import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String message;
  RegistrationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationLoaded extends RegistrationState {
  // Location lists
  final List<Map<String, dynamic>> countries;
  final List<String> states;
  final List<String> cities;

  // Profile options (could also come from API later)
  final List<String> genders;
  final List<String> hobbiesList;

  // Selected / entered values
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedCity;
  final String? name;
  final String? gender;
  final DateTime? dob;
  final List<String> selectedHobbies;

  RegistrationLoaded({
    required this.countries,
    required this.states,
    required this.cities,
    required this.genders,
    required this.hobbiesList,
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    this.name,
    this.gender,
    this.dob,
    this.selectedHobbies = const [],
  });

  RegistrationLoaded copyWith({
    List<Map<String, dynamic>>? countries,
    List<String>? states,
    List<String>? cities,
    List<String>? genders,
    List<String>? hobbiesList,
    String? selectedCountry,
    String? selectedState,
    String? selectedCity,
    String? name,
    String? gender,
    DateTime? dob,
    List<String>? selectedHobbies,
  }) {
    return RegistrationLoaded(
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      genders: genders ?? this.genders,
      hobbiesList: hobbiesList ?? this.hobbiesList,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedState: selectedState ?? this.selectedState,
      selectedCity: selectedCity ?? this.selectedCity,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
    );
  }

  @override
  List<Object?> get props => [
    countries,
    states,
    cities,
    genders,
    hobbiesList,
    selectedCountry,
    selectedState,
    selectedCity,
    name,
    gender,
    dob,
    selectedHobbies,
  ];
}
