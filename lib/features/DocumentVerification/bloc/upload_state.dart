import 'package:equatable/equatable.dart';
import 'dart:io';

class UploadState extends Equatable {
  final Map<String, File?> pickedFiles; // store per document type

  const UploadState({this.pickedFiles = const {}});

  UploadState copyWith({Map<String, File?>? pickedFiles}) {
    return UploadState(pickedFiles: pickedFiles ?? this.pickedFiles);
  }

  @override
  List<Object?> get props => [pickedFiles];
}
