import 'package:bandhana/features/Registration/repositories/registration_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationRepository repo = RegistrationRepository();
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegisterUserEvent>(registerUser);
  }

  registerUser(RegisterUserEvent event, Emitter emit) async {
    emit(RegistrationLoading());
    try {
      final response = await repo.registerUser(
        fullName: event.fullName,
        genderId: event.genderId,
        nationalityId: event.nationalityId,
        stateId: event.stateId,
        districtId: event.districtId,
        birthPlace: event.birthPlace,
        dateOfBirth: event.dateOfBirth,
        birthTime: event.birthTime,
        zodiacId: event.zodiacId,
        religionId: event.religionId,
        casteId: event.casteId,
        maritalStatusId: event.maritalStatusId,
        hobbiesList: event.hobbiesList,
        motherTongueId: event.motherTongueId,
        bloodGroupId: event.bloodGroupId,
        disability: event.disability,
        specificDisability: event.specificDisability,
        kul: event.kul,
        contactNumber: event.contactNumber,
        email: event.email,
      );
      if (response['status'] == "success") {
        emit(
          RegistrationSuccess(response['message'] ?? 'Registration successful'),
        );
      } else {
        emit(RegistrationFailure(response['message'] ?? 'Registration failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }
}
