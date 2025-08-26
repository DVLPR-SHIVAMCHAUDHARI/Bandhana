import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileSetupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends ProfileSetupState {}

class PickImageLoadingState extends ProfileSetupState {}

class PickImageLoadedState extends ProfileSetupState {
  final List<XFile> images;
  PickImageLoadedState(this.images);
  @override
  List<Object?> get props => [images];
}

class PickImageFailureState extends ProfileSetupState {
  final String error;
  PickImageFailureState(this.error);
  @override
  List<Object?> get props => [error];
}

class ProfileUpdatedState extends ProfileSetupState {
  final Map<String, dynamic> profileData;
  ProfileUpdatedState(this.profileData);
  @override
  List<Object?> get props => [profileData];
}
