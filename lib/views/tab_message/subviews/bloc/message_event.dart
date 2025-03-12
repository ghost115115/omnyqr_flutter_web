part of 'message_bloc.dart';

class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class InitEvemt extends MessageEvent {
  final String? id;
  const InitEvemt({this.id});
}

class AceptInvitation extends MessageEvent {
  final String? messageId;
  final bool? value;
  const AceptInvitation({this.messageId, this.value});
}
