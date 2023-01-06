import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/resources/colors.dart';

import 'diplay_file.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard(
      {super.key,
      required this.message,
      required this.date,
      required this.type});
  final String message;
  final String date;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
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
                      top: 5, bottom: 20, left: 30, right: 10)
                  : const EdgeInsets.only(
                      top: 5, bottom: 25, left: 5, right: 5),
              child: DisplayFile(message: message, type: type),
            ),
            Positioned(
                bottom: 2,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    )
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
