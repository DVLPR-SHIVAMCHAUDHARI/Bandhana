import 'dart:io';

abstract class UploadState {
  final Map<String, File?> pickedFiles;
  const UploadState({this.pickedFiles = const {}});
}

class UploadInitial extends UploadState {
  UploadInitial() : super(pickedFiles: {});
}

class UploadSuccess extends UploadState {
  UploadSuccess(Map<String, File?> pickedFiles)
    : super(pickedFiles: pickedFiles);
}

class UploadPermissionDenied extends UploadState {
  final String permissionFor;
  UploadPermissionDenied(this.permissionFor, Map<String, File?> pickedFiles)
    : super(pickedFiles: pickedFiles);
}

class UploadPermissionPermanentlyDenied extends UploadState {
  final String permissionFor;
  UploadPermissionPermanentlyDenied(
    this.permissionFor,
    Map<String, File?> pickedFiles,
  ) : super(pickedFiles: pickedFiles);
}

class UploadSubmitLoading extends UploadState {}

class UploadSubmitSuccess extends UploadState {
  final String message;
  UploadSubmitSuccess(this.message);
}

class UploadSubmitFailure extends UploadState {
  final String error;
  UploadSubmitFailure(this.error);
}
