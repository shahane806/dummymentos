import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/repository/uploaddocs_repo.dart';
import '../../constants/enums.dart';
import 'upload_docs_event.dart';
import 'upload_docs_state.dart';

class UploadDocsBloc extends Bloc<UploadEvent, UploadDocsState> {
  final UploaddocsRepo uploaddocsRepo = UploaddocsRepo();

  UploadDocsBloc() : super(UploadDocsState()) {
    on<UploadDocsEvent>(uploadDocstoAPI);
  }

  Future<void> uploadDocstoAPI(
      UploadDocsEvent event, Emitter<UploadDocsState> emit) async {
    try {
      emit(state.copyWith(
        uploadDocStatus: UploadDocStatus.loading,
      ));

      await uploaddocsRepo.uploadDocsToApi(
        event.section,
        event.district,
        event.taluka,
        event.docformat,
        event.docId,
        event.doctype,
        event.documentFile,
        event.remarked,
        event.password,
        event.state,
      );

      emit(state.copyWith(
        uploadDocStatus: UploadDocStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(uploadDocStatus: UploadDocStatus.failure));
    }
  }
}
