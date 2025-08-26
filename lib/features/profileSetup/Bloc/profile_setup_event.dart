import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends ProfileSetupEvent {}

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
