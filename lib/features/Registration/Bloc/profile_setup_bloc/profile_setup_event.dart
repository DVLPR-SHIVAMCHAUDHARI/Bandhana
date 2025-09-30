import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Pick multiple images (without cropping)
class PickImageEvent extends ProfileSetupEvent {
  final int limit;
  PickImageEvent({required this.limit});

  @override
  List<Object?> get props => [limit];
}

/// Pick cropped images (after cropping)
class PickCroppedImagesEvent extends ProfileSetupEvent {
  final List<XFile> images;
  PickCroppedImagesEvent({required this.images});

  @override
  List<Object?> get props => [images];
}

/// Remove image at index
class RemoveImageEvent extends ProfileSetupEvent {
  final int index;
  RemoveImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Update single field in profile
class UpdateFieldEvent extends ProfileSetupEvent {
  final String field;
  final dynamic value;
  UpdateFieldEvent({required this.field, required this.value});
}

/// Save draft
class SaveDraftEvent extends ProfileSetupEvent {}

/// Navigate to next screen
class NextEvent extends ProfileSetupEvent {}

/// Submit profile
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
