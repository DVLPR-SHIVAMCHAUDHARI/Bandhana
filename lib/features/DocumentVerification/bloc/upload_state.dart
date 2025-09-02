import 'dart:io';

abstract class UploadState {
  final Map<String, File?> pickedFiles;
  const UploadState({this.pickedFiles = const {}});
}

class UploadInitial extends UploadState {
  const UploadInitial() : super(pickedFiles: const {});
}

class UploadInProgress extends UploadState {
  const UploadInProgress(Map<String, File?> pickedFiles)
    : super(pickedFiles: pickedFiles);
}

class UploadSuccess extends UploadState {
  const UploadSuccess(Map<String, File?> pickedFiles)
    : super(pickedFiles: pickedFiles);
}

class UploadPermissionDenied extends UploadState {
  final String permission;
  const UploadPermissionDenied(this.permission, Map<String, File?> pickedFiles)
    : super(pickedFiles: pickedFiles);
}

class UploadPermissionPermanentlyDenied extends UploadState {
  final String permission;
  const UploadPermissionPermanentlyDenied(
    this.permission,
    Map<String, File?> pickedFiles,
  ) : super(pickedFiles: pickedFiles);
}
