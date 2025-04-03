class DocumentModel {
  final String id;
  final String path;
  final String size;
  final String uploadDate;

  DocumentModel({
    required this.id,
    required this.path,
    required this.size,
    required this.uploadDate,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['docId'] ?? '',
      path: json['docPath'] ?? '',
      size: json['size'] ?? '',
      uploadDate: json['created'] ?? '',
    );
  }
}
