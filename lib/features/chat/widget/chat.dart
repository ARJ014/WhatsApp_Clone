// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/provider/messageReply.dart';

import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/features/chat/widget/MyMessageCard.dart';
import 'package:whatsapp_clone/features/chat/widget/SenderMessages.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatScreen({
    required this.receiverId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void messageReplyHandler(String message, bool isMe, MessageEnum type) {
    ref.read(MessageReplyProvider.state).update((state) =>
        MessageReply(message: message, isMe: isMe, messageType: type));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream:
          ref.watch(ChatControllerProvider).getchatMessages(widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          const LoadingScreen();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (messageController.hasClients) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          }
        });
        return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              var message = snapshot.data![index];

              if (!message.isSeen &&
                  message.reciverId == FirebaseAuth.instance.currentUser!.uid) {
                ref
                    .read(ChatControllerProvider)
                    .setSeen(context, widget.receiverId, message.messageId);
              }

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(message.timesent),
                  type: message.type,
                  repliedMessageType: message.repliedMessageType,
                  repliedText: message.repliedMessage,
                  username: message.repliedTo,
                  onLeftSwipe: () {
                    messageReplyHandler(message.text, true, message.type);
                  },
                  isSeen: message.isSeen,
                );
              } else {
                return SenderMessageCard(
                  message: message.text,
                  date: DateFormat.Hm().format(message.timesent),
                  type: message.type,
                  onRightSwipe: () {
                    messageReplyHandler(message.text, false, message.type);
                  },
                  repliedMessageType: message.repliedMessageType,
                  repliedText: message.repliedMessage,
                  username: message.repliedTo,
                );
              }
            }));
      },
    );
  }
}
