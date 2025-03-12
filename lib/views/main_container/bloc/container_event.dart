import 'package:equatable/equatable.dart';
import 'package:omnyqr/views/main_container/bloc/container_state.dart';
import '../../../models/user.dart';

abstract class ContainerEvent extends Equatable {
  const ContainerEvent();
  @override
  List<Object?> get props => [];
}

class ContainerInit extends ContainerEvent {}

class BottomBarSelectionChange extends ContainerEvent {
  final int selectedIndex;
  const BottomBarSelectionChange({required this.selectedIndex});
}

class ContainerReloadUserEvent extends ContainerEvent {}

class ContainerShowLoading extends ContainerEvent {}

class ContainerHideLoading extends ContainerEvent {}

class RefreshUtilities extends ContainerEvent {}

class LogoutEvent extends ContainerEvent {}

class UpdateUserEvent extends ContainerEvent {
  final User? user;
  const UpdateUserEvent({this.user});
}

class AccountDeleteEvent extends ContainerEvent {}

class RefreshThreadsEvent extends ContainerEvent {
  final bool? isInvitation;
  const RefreshThreadsEvent({this.isInvitation});
}

class SendNotificationEvent extends ContainerEvent {
  final String? id;
  final String? type;
  final String? name;
  const SendNotificationEvent({this.id, this.type, this.name});
}

class SetUserAvailability extends ContainerEvent {
  final UserAvailability? availability;
  const SetUserAvailability({this.availability});
}

class SetIsAccepted extends ContainerEvent {
  final bool? isAccepted;
  const SetIsAccepted({this.isAccepted});
}

class SetAccountLevelEvent extends ContainerEvent {
  final String? value;
  final String? productID;
  final String? token;
  const SetAccountLevelEvent({this.value, this.productID, this.token});
}

class LoadUtilsEvent extends ContainerEvent {}

class SetIndexCall extends ContainerEvent {
  final int indexCall;
  SetIndexCall(this.indexCall);
}
