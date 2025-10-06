import 'package:MilanMandap/features/Registration/repositories/profile_setup_repository.dart';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final List<XFile> _images = []; // Bloc-owned image list
  Map<String, dynamic> profileData = {};
  final ProfileSetupRepository repo = ProfileSetupRepository();

  ProfileSetupBloc() : super(InitialState()) {
    /// Pick multiple images (without cropping)
    on<PickImageEvent>((event, emit) async {
      try {
        emit(PickImageLoadingState());
        final ImagePicker picker = ImagePicker();
        final List<XFile> pickedFiles = await picker.pickMultiImage(
          limit: event.limit,
        );

        if (pickedFiles.isNotEmpty) {
          final remainingSlots = 5 - _images.length;
          final filesToAdd = pickedFiles.take(remainingSlots).toList();
          _images.addAll(filesToAdd);
        }

        emit(PickImageLoadedState(List.from(_images)));
      } catch (e) {
        emit(PickImageFailureState(e.toString()));
      }
    });

    /// Pick cropped images (after cropping)
    on<PickCroppedImagesEvent>((event, emit) {
      final remainingSlots = 5 - _images.length;
      final filesToAdd = event.images.take(remainingSlots).toList();
      _images.addAll(filesToAdd);

      emit(PickImageLoadedState(List.from(_images)));
    });

    /// Remove an image
    on<RemoveImageEvent>((event, emit) {
      if (event.index >= 0 && event.index < _images.length) {
        _images.removeAt(event.index);
      }
      emit(PickImageLoadedState(List.from(_images)));
    });

    /// Update a field in profile data
    on<UpdateFieldEvent>((event, emit) {
      profileData[event.field] = event.value;
      emit(ProfileUpdatedState(Map.from(profileData)));
    });

    /// Submit profile along with images
    on<SubmitProfileEvent>((event, emit) async {
      emit(ProfileSetupSubmitLoadingState());
      try {
        final response = await repo.profileSetup(
          bio: event.bio,
          age: event.age,
          height: event.height,
          education: event.education,
          profession: event.profession,
          salary: event.salary,
          permanentLocation: event.permanentLocation,
          workLocation: event.workLocation,
          images: _images, // ✅ pass XFile list directly
        );

        if (response['status'] == "success") {
          emit(
            ProfileSetupSubmitSuccessState(
              response['message'] ?? "Profile submitted successfully!",
            ),
          );
        } else {
          emit(
            ProfileSetupSubmitFailureState(
              response['message'] ?? "Failed to submit profile",
            ),
          );
        }
      } catch (e) {
        logger.e(e);
        emit(ProfileSetupSubmitFailureState("Failed to submit profile: $e"));
      }
    });
  }

  /// Expose images for UI
  List<XFile> get images => List.unmodifiable(_images);
}
