import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/message.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository;
  MessageBloc(this._messageRepository) : super(MessageInitial()) {
    on<InitEvemt>(_onInit);
    on<AceptInvitation>(_onAcept);
  }

  _onInit(InitEvemt event, Emitter<MessageState> emit) async {
    emit(state.copyWith(isLoading: true));
    var response = await _messageRepository.getMessage(event.id ?? '');
    if (response.isSuccess) {
      emit(state.copyWith(
          messages: response.value,
          status: MessageStatus.success,
          isLoading: false));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(status: MessageStatus.networkError));
          break;
        default:
          emit(state.copyWith(status: MessageStatus.error));
      }
    }
  }

  _onAcept(AceptInvitation event, Emitter<MessageState> emit) async {
    emit(state.copyWith(status: MessageStatus.sending));
    ApiResponse<Message> response = await _messageRepository.acceptInvitation(
        event.messageId ?? '', event.value ?? false);
    if (response.isSuccess) {
      if (event.value == true) {
        emit(state.copyWith(status: MessageStatus.acepted));
      } else {
        emit(state.copyWith(status: MessageStatus.refused));
      }
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(status: MessageStatus.networkError));
          break;
        default:
          emit(state.copyWith(status: MessageStatus.error));
      }
    }
  }
}
