import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/constants/enums.dart';
import 'package:scanningapp/repository/fetchdocdata_repo.dart';

import 'fetch_docs_event.dart';
import 'fetch_docs_state.dart';

class FetchDocsBloc extends Bloc<DocsEvent, FetchDocsState> {
  final FetchdocdataRepo fetchdocdataRepo = FetchdocdataRepo();
  int currentPage = 1;
  final int limit = 6;
  bool isFetching = false;

  FetchDocsBloc() : super(FetchDocsState()) {
    on<FetchDocsEvent>(fetchDocsEvent);
  }

  Future<void> fetchDocsEvent(
      FetchDocsEvent event, Emitter<FetchDocsState> emit) async {
    print("Current Page ${currentPage}");
    if (isFetching) return;
    isFetching = true;

    if (event.isNewSearch) {
      currentPage = 1;
      emit(state
          .copywith(documentList: [], fetchdocstatus: FetchDocStatus.loading));
    } else {
      emit(state.copywith(fetchdocstatus: FetchDocStatus.loading));
    }

    try {
      final docslist = await fetchdocdataRepo.fetchdocsData(
          event.state,
          event.section,
          event.district,
          event.taluka,
          event.documentformat,
          event.docstype,
          currentPage,
          limit); //event.page,
      //  event.limit);
      print("fetchBloc Doc list : $docslist");
      int totalpages = fetchdocdataRepo.totalPages;

      if (docslist.isEmpty || currentPage > totalpages) {
        emit(state.copywith(fetchdocstatus: FetchDocStatus.success));
        return;
      }

      // upload_documents/MAHARASHTRA/Ahmednagar/Pathardi/E-Forest Depart/A0/MAP/sample.pdf

      // Scanned Document Folder/E-Forest Depart/MAHARASHTRA/NASHIK/NASHIK/A0/RECEIPTS/SAMPLE.pdf

      emit(state.copywith(
          documentList: (currentPage == 1)
              ? docslist
              : [...state.documentList, ...docslist],
          fetchdocstatus: FetchDocStatus.success));
      if (docslist.isNotEmpty) {
        currentPage++;
      }
    } catch (e) {
      emit(state.copywith(
        fetchdocstatus: FetchDocStatus.failure,
      ));
    } finally {
      isFetching = false;
    }
  }
}
