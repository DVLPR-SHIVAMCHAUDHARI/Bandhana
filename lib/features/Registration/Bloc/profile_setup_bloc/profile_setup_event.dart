import 'package:equatable/equatable.dart';

abstract class ProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends ProfileSetupEvent {
  final int limit;
  PickImageEvent({required this.limit});
  @override
  List<Object?> get props => [limit];
}

class RemoveImageEvent extends ProfileSetupEvent {
  final int index;
  RemoveImageEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class UpdateFieldEvent extends ProfileSetupEvent {
  final String field;
  final dynamic value;
  UpdateFieldEvent({required this.field, required this.value});
}

class SaveDraftEvent extends ProfileSetupEvent {}

class NextEvent extends ProfileSetupEvent {}

class SubmitProfileEvent extends ProfileSetupEvent {
  final String bio;
  final String age;
  final String height;
  final String salary;
  final String permanentLocation;
  final String workLocation;
  final String education;
  final String profession;

  SubmitProfileEvent({
    required this.bio,
    required this.age,
    required this.height,
    required this.salary,
    required this.permanentLocation,
    required this.workLocation,
    required this.education,
    required this.profession,
  });

  @override
  List<Object?> get props => [
    bio,
    age,
    height,
    salary,
    education,
    profession,
    permanentLocation,
    workLocation,
  ];
}
