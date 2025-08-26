import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> images = [];
  final Map<String, dynamic> profileData = {};

  ProfileSetupBloc() : super(InitialState()) {
    on<PickImageEvent>(_pickImages);
    on<RemoveImageEvent>(_removeImage);
    on<UpdateFieldEvent>(_updateField);
    on<SaveDraftEvent>(_saveDraft);
    on<NextEvent>(_next);
  }

  void _pickImages(PickImageEvent event, Emitter emit) async {
    emit(PickImageLoadingState());
    try {
      final List<XFile>? picked = await _picker.pickMultiImage();
      if (picked != null && picked.isNotEmpty) {
        images.addAll(picked);
        emit(PickImageLoadedState(List.from(images)));
      } else {
        emit(PickImageFailureState("No images selected"));
      }
    } catch (e) {
      emit(PickImageFailureState(e.toString()));
    }
  }

  void _removeImage(RemoveImageEvent event, Emitter emit) {
    if (event.index >= 0 && event.index < images.length) {
      images.removeAt(event.index);
      emit(PickImageLoadedState(List.from(images)));
    }
  }

  void _updateField(UpdateFieldEvent event, Emitter emit) {
    profileData[event.field] = event.value;
    emit(ProfileUpdatedState(Map.from(profileData)));
  }

  void _saveDraft(SaveDraftEvent event, Emitter emit) {
    // You can save draft logic here (e.g., local storage)
    emit(ProfileUpdatedState(Map.from(profileData)));
  }

  void _next(NextEvent event, Emitter emit) {
    // Validation and navigation logic here
    emit(ProfileUpdatedState(Map.from(profileData)));
  }
}
