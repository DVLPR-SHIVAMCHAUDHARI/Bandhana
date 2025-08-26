abstract class RegistrationEvent {}

/// Load initial data (countries, genders, hobbies, etc.)
class LoadRegistrationData extends RegistrationEvent {}

/// Location selections
class SelectCountry extends RegistrationEvent {
  final String country;
  SelectCountry(this.country);
}

class SelectState extends RegistrationEvent {
  final String state;
  SelectState(this.state);
}

class SelectCity extends RegistrationEvent {
  final String city;
  SelectCity(this.city);
}

/// Profile field updates
class UpdateName extends RegistrationEvent {
  final String name;
  UpdateName(this.name);
}

class UpdateGender extends RegistrationEvent {
  final String gender;
  UpdateGender(this.gender);
}

class UpdateDob extends RegistrationEvent {
  final DateTime dob;
  UpdateDob(this.dob);
}

class UpdateHobbies extends RegistrationEvent {
  final List<String> hobbies;
  UpdateHobbies(this.hobbies);
}
