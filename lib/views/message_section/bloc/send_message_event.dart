part of 'send_message_bloc.dart';

class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendMessageInitEvemt extends SendMessageEvent {
  final String? id;
  const SendMessageInitEvemt({this.id});
}

class MessageChangeEvent extends SendMessageEvent {
  final String? value;
  const MessageChangeEvent({this.value});
}

class SendFormEvent extends SendMessageEvent {}
