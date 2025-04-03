import 'package:equatable/equatable.dart';

abstract class DocsEvent extends Equatable {}

// ignore: must_be_immutable
class FetchDocsEvent extends DocsEvent {
  String state;
  String section;
  String district;
  String taluka;
  String documentformat;
  String docstype;
  bool isNewSearch;

  FetchDocsEvent(
      {required this.state,
      required this.section,
      required this.district,
      required this.taluka,
      required this.documentformat,
      required this.docstype,
      this.isNewSearch = false});

  @override
  List<Object?> get props =>
      [state, section, district, taluka, documentformat, docstype, isNewSearch];
}
