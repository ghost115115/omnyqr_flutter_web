import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/models/message.dart';
import 'package:omnyqr/repositories/message/message_repository.dart';
part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final MessageRepository _messageRepository;
  SendMessageBloc(this._messageRepository) : super(SendMessageInitial()) {
    on<SendMessageInitEvemt>(_onInit);
    on<MessageChangeEvent>(_onChange);
    on<SendFormEvent>(_onForm);
  }

  _onInit(SendMessageInitEvemt event, Emitter<SendMessageState> emit) {
    emit(state.copyWith(id: event.id));
  }

  _onChange(MessageChangeEvent event, Emitter<SendMessageState> emit) {
    emit(state.copyWith(message: event.value));
  }

  _onForm(SendFormEvent event, Emitter<SendMessageState> emit) async {
    ApiResponse<List<Message>?> response = await _messageRepository.sendMessage(
        state.id ?? '', state.message ?? '');

    if (response.isSuccess) {
      emit(state.copyWith(status: SendStatus.success));
    } else {
      switch (response.message) {
        case "connectionError":
          emit(state.copyWith(status: SendStatus.networkError));
          break;
        default:
          emit(state.copyWith(status: SendStatus.error));
      }
    }
  }
}
