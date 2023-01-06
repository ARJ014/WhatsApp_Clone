// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class chatTextField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const chatTextField({
    Key? key,
    required this.recieverUserId,
  }) : super(key: key);

  @override
  ConsumerState<chatTextField> createState() => _chatTextFieldState();
}

class _chatTextFieldState extends ConsumerState<chatTextField> {
  bool showIsSendbutton = false;
  final textController = TextEditingController();
  void sendTextMessage() {
    if (showIsSendbutton) {
      ref
          .read(ChatControllerProvider)
          .sendTextmessage(context, textController.text, widget.recieverUserId);
    }
    setState(() {
      textController.text = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void sendFile(File file, MessageEnum messageEnum) {
    ref
        .read(ChatControllerProvider)
        .sendFilemessage(context, file, widget.recieverUserId, messageEnum);
  }

  void selectImage() async {
    File? file = await pickImageFromGallery(context);
    if (file != null) {
      sendFile(file, MessageEnum.image);
    }
  }

  void selectvideo() async {
    File? file = await pickVideoFromGallery(context);
    if (file != null) {
      sendFile(file, MessageEnum.video);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: textController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  showIsSendbutton = true;
                });
              } else {
                setState(() {
                  showIsSendbutton = false;
                });
              }
            },
            decoration: InputDecoration(
              prefixIcon: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.emoji_emotions, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.gif, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera, color: Colors.grey),
                      onPressed: selectImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: selectvideo,
                    ),
                  ],
                ),
              ),
              fillColor: mobileChatBoxColor,
              contentPadding: const EdgeInsets.only(left: 20),
              filled: true,
              hintText: "Type your message...",
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 2, left: 2),
          child: CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 25,
              child: GestureDetector(
                onTap: () => sendTextMessage(),
                child: Icon(showIsSendbutton ? Icons.send : Icons.mic,
                    color: textColor),
              )),
        )
      ],
    );
  }
}
