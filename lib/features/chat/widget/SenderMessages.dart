// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/resources/colors.dart';

import 'diplay_file.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final MessageEnum repliedMessageType;
  final String repliedText;
  final String username;

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedMessageType,
    required this.repliedText,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 95),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            )),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Stack(children: [
              Padding(
                padding: (type == MessageEnum.text)
                    ? const EdgeInsets.only(
                        top: 5,
                        bottom: 20,
                        left: 10,
                        right: 100,
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
                  bottom: (type == MessageEnum.text) ? 2 : 4,
                  right: 5,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(width: 3),
                    ],
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
