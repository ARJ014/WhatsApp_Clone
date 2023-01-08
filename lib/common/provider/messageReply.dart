// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageType;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageType,
  });
}

final MessageReplyProvider = StateProvider<MessageReply?>((ref) => null);
