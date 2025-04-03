// import 'package:equatable/equatable.dart';

// abstract class DropdownState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class DropdownInitial extends DropdownState {}

// class DropdownLoading extends DropdownState {}

// class DropdownLoaded extends DropdownState {
//   final List<String> items;
//   DropdownLoaded(this.items);

//   @override
//   List<Object?> get props => [items];
// }

// class DropdownError extends DropdownState {
//   final String message;
//   DropdownError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

import 'package:equatable/equatable.dart';

class DropdownState extends Equatable {
  final List<String> section;
  final List<String> district;
  final List<String> taluka;
  final List<String> division;
  final List<String> states;
  final List<String> documentFormat;
  final List<String> documentType;
  final bool isStateLoading;
  final bool isDocumentFormatLoading;
  final bool isDocumentTypeLoading;
  final bool isSectionLoading;
  final bool isDistrictLoading;
  final bool isTalukaLoading;
  final bool isDivisionLoading;
  final String? errorMessage;

  DropdownState({
    this.isStateLoading = false,
    this.isDocumentFormatLoading = false,
    this.isDocumentTypeLoading = false,
    this.states = const [],
    this.documentFormat = const [],
    this.documentType = const [],
    this.section = const [],
    this.district = const [],
    this.taluka = const [],
    this.division = const [],
    this.isSectionLoading = false,
    this.isDistrictLoading = false,
    this.isTalukaLoading = false,
    this.isDivisionLoading = false,
    this.errorMessage,
  });

  DropdownState copyWith({
    List<String>? states,
    List<String>? sections,
    List<String>? districts,
    List<String>? talukas,
    List<String>? divisions,
    List<String>? documentFormat,
    List<String>? documentType,
    bool? isStateLoading,
    bool? isSectionLoading,
    bool? isDistrictLoading,
    bool? isTalukaLoading,
    bool? isDivisionLoading,
    bool? isDocumentFormatLoading,
    bool? isDocumentTypeLoading,
    String? errorMessage,
  }) {
    return DropdownState(
      states: states ?? this.states,
      section: sections ?? this.section,
      district: districts ?? this.district,
      taluka: talukas ?? this.taluka,
      division: divisions ?? this.division,
      documentFormat: documentFormat ?? this.documentFormat,
      documentType: documentType ?? this.documentType,
      isDocumentFormatLoading:
          isDocumentFormatLoading ?? this.isDocumentFormatLoading,
      isDocumentTypeLoading:
          isDocumentTypeLoading ?? this.isDocumentTypeLoading,
      isStateLoading: isStateLoading ?? this.isStateLoading,
      isSectionLoading: isSectionLoading ?? this.isSectionLoading,
      isDistrictLoading: isDistrictLoading ?? this.isDistrictLoading,
      isTalukaLoading: isTalukaLoading ?? this.isTalukaLoading,
      isDivisionLoading: isDivisionLoading ?? this.isDivisionLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        section,
        district,
        taluka,
        division,
        states,
        documentFormat,
        documentType,
        isStateLoading,
        isSectionLoading,
        isDistrictLoading,
        isTalukaLoading,
        isDivisionLoading,
        errorMessage
      ];
}
