import 'dart:io';

abstract class UploadEvent {}

class UploadFromCamera extends UploadEvent {
  final String docType;
  UploadFromCamera(this.docType);
}

class UploadFromGallery extends UploadEvent {
  final String docType;
  UploadFromGallery(this.docType);
}

class UploadFromFile extends UploadEvent {
  final String docType;
  UploadFromFile(this.docType);
}

class SubmitUploadEvent extends UploadEvent {
  final String aadhaarOrPan;
  final String casteCertificate;

  final File? aadhaarOrPanFile;
  final File? liveSelfieFile;
  final File? casteCertificateFile;
  final File? selfieWithIdFile;

  SubmitUploadEvent({
    required this.aadhaarOrPan,
    required this.casteCertificate,
    this.aadhaarOrPanFile,
    this.liveSelfieFile,
    this.casteCertificateFile,
    this.selfieWithIdFile,
  });
}
