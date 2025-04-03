import 'package:equatable/equatable.dart';

import '../../constants/enums.dart';
import '../../models/document_model.dart';

class FetchDocsState extends Equatable {
  final List<DocumentModel> documentList;
  final FetchDocStatus fetchDocStatus;

  FetchDocsState(
      {this.documentList = const [],
      this.fetchDocStatus = FetchDocStatus.initial});

  FetchDocsState copywith(
      {List<DocumentModel>? documentList, FetchDocStatus? fetchdocstatus}) {
    return FetchDocsState(
        documentList: documentList ?? this.documentList,
        fetchDocStatus: fetchdocstatus ?? this.fetchDocStatus);
  }

  @override
  List<Object?> get props => [documentList, fetchDocStatus];
}
