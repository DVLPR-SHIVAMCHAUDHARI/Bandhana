import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileSetupState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state
class InitialState extends ProfileSetupState {}

/// Loading state while picking images
class PickImageLoadingState extends ProfileSetupState {}

/// Loaded state with list of images
class PickImageLoadedState extends ProfileSetupState {
  final List<XFile> images;
  PickImageLoadedState(this.images);

  @override
  List<Object?> get props => [images];
}

/// Error while picking images
class PickImageFailureState extends ProfileSetupState {
  final String error;
  PickImageFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

/// State when a field is updated in profile
class ProfileUpdatedState extends ProfileSetupState {
  final Map<String, dynamic> profileData;
  ProfileUpdatedState(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

/// Profile submission loading
class ProfileSetupSubmitLoadingState extends ProfileSetupState {}

/// Profile submission success
class ProfileSetupSubmitSuccessState extends ProfileSetupState {
  final String message;
  ProfileSetupSubmitSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Profile submission failure
class ProfileSetupSubmitFailureState extends ProfileSetupState {
  final String error;
  ProfileSetupSubmitFailureState(this.error);

  @override
  List<Object?> get props => [error];
}
