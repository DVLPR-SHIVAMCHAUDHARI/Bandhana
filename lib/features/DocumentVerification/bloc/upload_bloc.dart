import 'dart:io';

import 'package:bandhana/features/DocumentVerification/bloc/upload_event.dart';
import 'package:bandhana/features/DocumentVerification/bloc/upload_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(const UploadInitial()) {
    on<UploadFromCamera>(_handleCameraUpload);
    on<UploadFromGallery>(_handleGalleryUpload);
    on<UploadFromFile>(_handleFileUpload);
  }

  Future<void> _handleCameraUpload(
    UploadFromCamera event,
    Emitter<UploadState> emit,
  ) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera);
      if (picked != null) {
        emit(
          UploadSuccess({
            ...state.pickedFiles,
            event.docType: File(picked.path),
          }),
        );
      }
    } else if (status.isPermanentlyDenied) {
      emit(UploadPermissionPermanentlyDenied("Camera", state.pickedFiles));
    } else {
      emit(UploadPermissionDenied("Camera", state.pickedFiles));
    }
  }

  Future<void> _handleGalleryUpload(
    UploadFromGallery event,
    Emitter<UploadState> emit,
  ) async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        emit(
          UploadSuccess({
            ...state.pickedFiles,
            event.docType: File(picked.path),
          }),
        );
      }
    } else if (status.isPermanentlyDenied) {
      emit(UploadPermissionPermanentlyDenied("Gallery", state.pickedFiles));
    } else {
      emit(UploadPermissionDenied("Gallery", state.pickedFiles));
    }
  }

  Future<void> _handleFileUpload(
    UploadFromFile event,
    Emitter<UploadState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      emit(
        UploadSuccess({
          ...state.pickedFiles,
          event.docType: File(result.files.single.path!),
        }),
      );
    }
  }
}
