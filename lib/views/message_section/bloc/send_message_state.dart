part of 'send_message_bloc.dart';

enum SendStatus { init, success, error, networkError }

class SendMessageState extends Equatable {
  final String? message;
  final SendStatus? status;
  final String? id;
  const SendMessageState({this.message, this.id, this.status});

  SendMessageState copyWith({String? message, String? id, SendStatus? status}) {
    return SendMessageState(
        message: message ?? this.message,
        id: id ?? this.id,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props => [message, id, status];
}

class SendMessageInitial extends SendMessageState {}
