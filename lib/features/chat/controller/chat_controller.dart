// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/provider/messageReply.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/model/chatContactModel.dart';
import 'package:whatsapp_clone/model/message.dart';

final ChatControllerProvider = Provider(((ref) {
  final chatRepository = ref.watch(ChatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
}));

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContactModel>> getchatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<MessageModel>> getchatMessages(String receiverId) {
    return chatRepository.getChatMessages(receiverId);
  }

  void sendTextmessage(context, String text, String recieverUserId) {
    final messageReply = ref.read(MessageReplyProvider);
    ref.read(AuthControllerProviderFuture).whenData((value) =>
        chatRepository.sendTextmessage(
            context: context,
            text: text,
            senderUser: value!,
            messageReply: messageReply,
            recieverUserId: recieverUserId));
    ref.read(MessageReplyProvider.state).update((state) => null);
  }

  void sendFilemessage(
      context, File file, String recieverUserId, MessageEnum messageEnum) {
    final messageReply = ref.read(MessageReplyProvider);

    ref
        .read(AuthControllerProviderFuture)
        .whenData((value) => chatRepository.sendFileMessage(
              context,
              ref,
              messageEnum,
              recieverUserId,
              value!,
              file,
              messageReply,
            ));
    ref.read(MessageReplyProvider.state).update((state) => null);
  }

  void setSeen(context, String recieverUserId, String messageId) {
    chatRepository.setSeen(context, recieverUserId, messageId);
  }
}
