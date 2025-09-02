import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickFileEvent extends UploadEvent {
  final String docType; // so we know which tile triggered it
  PickFileEvent(this.docType);

  @override
  List<Object?> get props => [docType];
}
