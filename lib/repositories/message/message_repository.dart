import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:omnyqr/clients/message/message_api_client.dart';
import 'package:omnyqr/commons/utils/api_response.dart';
import 'package:omnyqr/extensions/response_extension.dart';
import 'package:omnyqr/models/base_response.dart';
import 'package:omnyqr/models/message.dart';
import '../../models/thread.dart';

class MessageRepository {
  late final MessageApiClient _messageApiClient;
  MessageRepository(this._messageApiClient);

  Future<ApiResponse<List<Thread>?>> getThreads() async {
    try {
      final response = await _messageApiClient.getThreads();
      List<Thread>? threadList;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        threadList = jsonList.map((item) => Thread.fromJson(item)).toList();

        return ApiResponse(ResponseState.success, threadList, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<List<Message>?>> getMessage(String id) async {
    try {
      final response = await _messageApiClient.getMessages(id);

      List<Message>? messageList;
      if (response.isSuccess) {
        List<dynamic> jsonList = jsonDecode(response.data ?? "");
        messageList = jsonList.map((item) => Message.fromJson(item)).toList();

        return ApiResponse(ResponseState.success, messageList, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<Message>> acceptInvitation(String id, bool value) async {
    try {
      final response = await _messageApiClient.acceptInvitation(id, value);

      if (response.isSuccess) {
        Message message = Message.fromJson(jsonDecode(response.data ?? ""));

        return ApiResponse(ResponseState.success, message, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<String>> sendPush(
      String id, String type, String name) async {
    try {
      final response = await _messageApiClient.sendPush(id, type, name);

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, null, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }

  Future<ApiResponse<List<Message>?>> sendMessage(
      String id, String message) async {
    try {
      final response = await _messageApiClient.sendMessage(id, message);

      if (response.isSuccess) {
        return ApiResponse(ResponseState.success, null, null);
      } else {
        BaseResponse baseRespo =
            BaseResponse.fromJson(jsonDecode(response.data ?? ""));
        return ApiResponse(ResponseState.error, null, baseRespo.errorCode);
      }
    } on DioException catch (de) {
      return ApiResponse(ResponseState.error, null, de.type.name);
    }
  }
}
