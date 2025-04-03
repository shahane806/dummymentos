import 'package:equatable/equatable.dart';
import 'package:scanningapp/constants/enums.dart';

class UploadDocsState extends Equatable {
  final UploadDocStatus uploadDocStatus;
  final String message;

  const UploadDocsState(
      {this.uploadDocStatus = UploadDocStatus.initial, this.message = ""});

  UploadDocsState copyWith({
    UploadDocStatus? uploadDocStatus,
    String? message,
  }) {
    return UploadDocsState(
        uploadDocStatus: uploadDocStatus ?? this.uploadDocStatus,
        message: message ?? this.message
      );
  }

  @override
  List<Object?> get props => [uploadDocStatus, message];
}
