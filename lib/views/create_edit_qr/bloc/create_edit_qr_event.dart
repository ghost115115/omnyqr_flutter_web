part of 'create_edit_qr_bloc.dart';

class CreateEditQrEvent extends Equatable {
  const CreateEditQrEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends CreateEditQrEvent {
  final Association? association;
  final int? index;
  final bool? isEdit;

  const InitEvent({
    this.association,
    this.index,
    this.isEdit,
  });
}

class ToggleShowCheckBoxEvent extends CreateEditQrEvent {}

class ToggleShowSwitchEvent extends CreateEditQrEvent {}

class RegistryChangeEvent extends CreateEditQrEvent {
  final String? value;
  const RegistryChangeEvent({this.value});
}

class IntercomNameChangeEvent extends CreateEditQrEvent {
  final String? value;
  const IntercomNameChangeEvent({this.value});
}

class StartDateChangeEvent extends CreateEditQrEvent {
  final DateTime? value;
  final TimeOfDay? time;
  const StartDateChangeEvent({this.value, this.time});
}

class EndDateChangeEvent extends CreateEditQrEvent {
  final DateTime? value;
  final TimeOfDay? time;
  const EndDateChangeEvent({this.value, this.time});
}

class AddressChangeEvent extends CreateEditQrEvent {
  final String? value;
  final String? lat;
  final String? lng;
  const AddressChangeEvent({this.value, this.lat, this.lng});
}

class UrlChangeEvent extends CreateEditQrEvent {
  final String? value;
  const UrlChangeEvent({this.value});
}

class ReferentsChangeEvemt extends CreateEditQrEvent {
  final User? value;
  const ReferentsChangeEvemt({this.value});
}

class RemoveReferentEvent extends CreateEditQrEvent {
  final int? id;
  const RemoveReferentEvent({this.id});
}

class AssociationChangeEvent extends CreateEditQrEvent {
  final String? value;
  final String? associationId;
  const AssociationChangeEvent({this.value, this.associationId});
}

class SendFormEvent extends CreateEditQrEvent {}

class PickDocument extends CreateEditQrEvent {}

class PublicPrivateEvent extends CreateEditQrEvent {
  final bool value;
  const PublicPrivateEvent(this.value);
}

class SecretaryChangeEvent extends CreateEditQrEvent {
  final User? value;
  const SecretaryChangeEvent({this.value});
}

class SecretaryDeleteEvent extends CreateEditQrEvent {
  const SecretaryDeleteEvent();
}
