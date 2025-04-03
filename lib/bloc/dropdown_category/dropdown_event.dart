import 'package:equatable/equatable.dart';

abstract class DropdownEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadSections extends DropdownEvent {}

class LoadDocumentformats extends DropdownEvent {}

class LoadDocumentTypes extends DropdownEvent {}

class LoadState extends DropdownEvent {}

class LoadDistrict extends DropdownEvent {
  final String state;
  LoadDistrict(this.state);

  @override
  List<Object?> get props => [state];
}

class LoadTaluka extends DropdownEvent {
  final String district;
  LoadTaluka(this.district);

  @override
  List<Object?> get props => [district];
}

class LoadDivision extends DropdownEvent {
  final String taluka;
  LoadDivision(this.taluka);

  @override
  List<Object?> get props => [taluka];
}
