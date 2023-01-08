// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:whatsapp_clone/common/enum/message_enum.dart';

class MessageModel {
  final String senderId;
  final String reciverId;
  final String text;
  final String messageId;
  final DateTime timesent;
  final MessageEnum type;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.text,
    required this.messageId,
    required this.timesent,
    required this.type,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'reciverId': reciverId,
      'text': text,
      'messageId': messageId,
      'timesent': timesent.millisecondsSinceEpoch,
      'type': type.type,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      reciverId: map['reciverId'] as String,
      text: map['text'] as String,
      messageId: map['messageId'] as String,
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent'] as int),
      type: (map['type'] as String).toEnum(),
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map["repliedMessageType"] as String).toEnum(),
    );
  }
}
