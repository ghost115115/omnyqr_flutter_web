part of 'qr_tab_bloc.dart';

enum PageContent { anonimous, initialising }

class QrTabEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitEvent extends QrTabEvent {}

class HideCameraEvent extends QrTabEvent {}

class GetAssociation extends QrTabEvent {
  final String? id;
  final bool? isFromScan;
  GetAssociation({this.id, this.isFromScan});
}

class AssociationChangeEvent extends QrTabEvent {
  final String? id;
  AssociationChangeEvent({this.id});
}

class ResetDialogEvent extends QrTabEvent {}
