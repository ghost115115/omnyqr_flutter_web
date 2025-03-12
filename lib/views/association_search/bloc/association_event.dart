part of 'association_bloc.dart';

class AssociationEvent extends Equatable {
  const AssociationEvent();

  @override
  List<Object> get props => [];
}

class AssociationInitEvent extends AssociationEvent {
  final String? value;
  const AssociationInitEvent({this.value});
}

class AssociationRefreshEvemt extends AssociationEvent{}


class ResetAssociationStatus extends AssociationEvent{}
