import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class UploadEvent extends Equatable {}

class UploadDocsEvent extends UploadEvent {
  final String section;
  final String district;
  final String taluka;
  final String docformat;
  final String doctype;
  final String state;
  final String password;
  final String remarked;
  final String docId;
  final PlatformFile documentFile;

  UploadDocsEvent(
      {required this.docId,
      required this.remarked,
      required this.password,
      required this.section,
      required this.state,
      required this.district,
      required this.taluka,
      required this.docformat,
      required this.doctype,
      required this.documentFile});

  @override
  List<Object?> get props => [
        state,
        password,
        remarked,
        section,
        district,
        taluka,
        docformat,
        doctype,
        docId,
        documentFile
      ];
}
