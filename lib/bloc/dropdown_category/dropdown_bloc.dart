import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/dropdowndata_repo.dart';
import 'dropdown_event.dart';
import 'dropdown_state.dart';

// class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
//   final DropdowndataRepo dropdowndataRepo = DropdowndataRepo();

//   DropdownBloc() : super(DropdownState()) {
//     on<LoadSections>(fetchsectiondata);
//     on<LoadDistrict>(fetchdistrictdata);
//     on<LoadTaluka>(fetchtalukadata);
//     on<LoadDivision>(fetchdivisiondata);
//   }

// // Section
//   Future<void> fetchsectiondata(
//       LoadSections event, Emitter<DropdownState> emit) async {
//     emit(DropdownLoading());

//     try {
//       List<String> sections = await dropdowndataRepo.sectiondata();
//       emit(DropdownLoaded(sections));
//     } catch (e) {
//       emit(DropdownError("Failed to load section data"));
//     }
//   }

// // District
//   Future<void> fetchdistrictdata(
//       LoadDistrict event, Emitter<DropdownState> emit) async {
//     emit(DropdownLoading());

//     try {
//       List<String> districts =
//           await dropdowndataRepo.districtdata(event.section);
//       emit(DropdownLoaded(districts));
//     } catch (e) {
//       emit(DropdownError("Failed to load section data"));
//     }
//   }

//   // Taluka
//   Future<void> fetchtalukadata(
//       LoadTaluka event, Emitter<DropdownState> emit) async {
//     emit(DropdownLoading());

//     try {
//       List<String> talukas = await dropdowndataRepo.talukadata(event.district);
//       emit(DropdownLoaded(talukas));
//     } catch (e) {
//       emit(DropdownError("Failed to load section data"));
//     }
//   }

// // Division
//   Future<void> fetchdivisiondata(
//       LoadDivision event, Emitter<DropdownState> emit) async {
//     emit(DropdownLoading());

//     try {
//       List<String> divisions =
//           await dropdowndataRepo.divisiondata(event.taluka);
//       emit(DropdownLoaded(divisions));
//     } catch (e) {
//       emit(DropdownError("Failed to load section data"));
//     }
//   }
// }

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  final DropdowndataRepo dropdowndataRepo = DropdowndataRepo();

  DropdownBloc() : super(DropdownState()) {
    on<LoadSections>(_fetchSections);
    on<LoadDistrict>(_fetchDistricts);
    on<LoadTaluka>(_fetchTalukas);
    on<LoadState>(_fetchStates);
    on<LoadDocumentformats>(_fetchDocumentFormats);
    on<LoadDocumentTypes>(__fetchDocumentTypes);
  }

  Future<void> _fetchSections(
      LoadSections event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(
        isSectionLoading: true,
        sections: [],
        districts: [],
        talukas: [],
        divisions: []));

    try {
      List<String> sections = await dropdowndataRepo.sectiondata();
      emit(state.copyWith(
          sections: sections, isSectionLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isSectionLoading: false, errorMessage: "Failed to load sections"));
    }
  }

  Future<void> _fetchDocumentFormats(
      LoadDocumentformats event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(
        isDocumentFormatLoading: true,
        sections: [],
        districts: [],
        talukas: [],
        divisions: []));

    try {
      List<String> documentFormatsData =
          await dropdowndataRepo.documentFormatsData();
      emit(state.copyWith(
          documentFormat: documentFormatsData,
          isDocumentFormatLoading: false,
          errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isDocumentFormatLoading: false,
          errorMessage: "Failed to load sections"));
    }
  }

  Future<void> __fetchDocumentTypes(
      LoadDocumentTypes event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(
        isDocumentTypeLoading: true,
        sections: [],
        districts: [],
        talukas: [],
        divisions: []));

    try {
      List<String> documentTypesData =
          await dropdowndataRepo.documentTypesData();
      emit(state.copyWith(
          documentType: documentTypesData,
          isDocumentTypeLoading: false,
          errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isDocumentTypeLoading: false,
          errorMessage: "Failed to load sections"));
    }
  }

  Future<void> _fetchStates(
      LoadState event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(
        isStateLoading: true,
        states: [],
        districts: [],
        talukas: [],
        divisions: []));

    try {
      List<String> states = await dropdowndataRepo.statedata();
      emit(state.copyWith(
          states: states, isStateLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isStateLoading: false, errorMessage: "Failed to load states"));
    }
  }

  Future<void> _fetchDistricts(
      LoadDistrict event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(
        isDistrictLoading: true, districts: [], talukas: [], divisions: []));
    try {
      List<String> districts = await dropdowndataRepo.districtdata(event.state);
      emit(state.copyWith(
          districts: districts, isDistrictLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isDistrictLoading: false, errorMessage: "Failed to load districts"));
    }
  }

  Future<void> _fetchTalukas(
      LoadTaluka event, Emitter<DropdownState> emit) async {
    emit(state.copyWith(isTalukaLoading: true, talukas: [], divisions: []));
    try {
      List<String> talukas = await dropdowndataRepo.talukadata(event.district);
      emit(state.copyWith(
          talukas: talukas, isTalukaLoading: false, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(
          isTalukaLoading: false, errorMessage: "Failed to load talukas"));
    }
  }
}
