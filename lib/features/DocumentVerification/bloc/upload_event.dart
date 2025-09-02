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
