import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widget/diplay_file.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard(
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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
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
                      top: 5, bottom: 20, left: 10, right: 50)
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
                          const TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.done_all,
                      size: 16,
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
