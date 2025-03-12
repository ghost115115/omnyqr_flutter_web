part of 'association_create_bloc.dart';

class AssociationCreateEvent extends Equatable {
  const AssociationCreateEvent();

  @override
  List<Object> get props => [];
}

class AssociationCreateInitEvent extends AssociationCreateEvent {
  final String? value;

  const AssociationCreateInitEvent({this.value});
}

class NameChangeEvent extends AssociationCreateEvent {
  final String? value;
  const NameChangeEvent({this.value});
}

class AddressChangeEvent extends AssociationCreateEvent {
  final String? value;
  final String? lat;
  final String? long;
  const AddressChangeEvent({this.value, this.lat, this.long});
}

class FormSendEvent extends AssociationCreateEvent {}


class CreateAssociationReset extends AssociationCreateEvent{}