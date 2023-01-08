// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widget/diplay_file.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final MessageEnum repliedMessageType;
  final String repliedText;
  final String username;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedMessageType,
    required this.repliedText,
    required this.username,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 100),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            )),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Stack(children: [
              Padding(
                padding: (type == MessageEnum.text)
                    ? const EdgeInsets.only(
                        top: 5,
                        bottom: 20,
                        left: 6,
                        right: 10,
                      )
                    : const EdgeInsets.only(
                        top: 5,
                        bottom: 5,
                        left: 5,
                        right: 5,
                      ),
                child: Column(
                  children: [
                    if (isReplying) ...[
                      Container(
                        constraints: const BoxConstraints(minWidth: 68),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 3),
                            DisplayFile(
                                message: repliedText, type: repliedMessageType),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    const SizedBox(height: 3),
                    DisplayFile(message: message, type: type),
                  ],
                ),
              ),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 16,
                        color: isSeen ? Colors.blue : Colors.grey[400],
                      )
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
