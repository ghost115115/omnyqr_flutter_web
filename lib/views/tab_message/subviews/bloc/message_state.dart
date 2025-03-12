part of 'message_bloc.dart';

enum MessageStatus {
  init,
  loading,
  success,
  error,
  networkError,
  sending,
  acepted,
  refused
}

class MessageState extends Equatable {
  final List<Message>? messages;
  final MessageStatus? status;
  final bool? isLoading;
  const MessageState({this.messages, this.status, this.isLoading});

  MessageState copyWith(
      {List<Message>? messages, MessageStatus? status, bool? isLoading}) {
    return MessageState(
        messages: messages ?? this.messages,
        status: status ?? this.status,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [messages, status, isLoading];
}

class MessageInitial extends MessageState {}
