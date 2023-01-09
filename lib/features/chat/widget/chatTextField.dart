// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/provider/messageReply.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';

import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/widget/reply_message.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class chatTextField extends ConsumerStatefulWidget {
  final String reciever;
  final String recieverUserId;
  final bool isGroupChat;

  const chatTextField({
    Key? key,
    required this.recieverUserId,
    required this.reciever,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<chatTextField> createState() => _chatTextFieldState();
}

class _chatTextFieldState extends ConsumerState<chatTextField> {
  bool showEmojiPicker = false;
  bool showIsSendbutton = false;
  bool isRecoderInit = false;
  bool isRecording = false;
  FlutterSoundRecorder? _soundRecorder;
  Record? record;
  FocusNode focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    record = Record();
    // _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone access not given");
    }
    // await _soundRecorder!.openRecorder();
    isRecoderInit = true;
  }

  void sendTextMessage() async {
    if (showIsSendbutton) {
      ref.read(ChatControllerProvider).sendTextmessage(
            context,
            textController.text,
            widget.recieverUserId,
            widget.isGroupChat,
          );
      setState(() {
        textController.text = "";
      });
    } else {
      if (!isRecoderInit) {
        return;
      }
      if (isRecording) {
        final path = await record!.stop();
        if (path != null) {
          sendFile(File(path), MessageEnum.audio);
        }
      } else {
        await record!.start();
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    _soundRecorder!.closeRecorder();
    isRecoderInit = false;
  }

  void sendFile(File file, MessageEnum messageEnum) {
    ref.read(ChatControllerProvider).sendFilemessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
        );
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

  void toggleKeyboardEmoji() {
    if (showEmojiPicker) {
      setState(() {
        showEmojiPicker = false;
        focusNode.requestFocus();
      });
    } else {
      setState(() {
        showEmojiPicker = true;
        focusNode.unfocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(MessageReplyProvider);
    bool isReply = messageReply != null;
    return Column(
      children: [
        isReply
            ? MesssgeReplyPreview(receiver: widget.reciever)
            : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                          icon: const Icon(Icons.emoji_emotions,
                              color: Colors.grey),
                          onPressed: toggleKeyboardEmoji,
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
                          icon:
                              const Icon(Icons.attach_file, color: Colors.grey),
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
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
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
                    child: Icon(
                        showIsSendbutton
                            ? Icons.send
                            : !isRecording
                                ? Icons.mic
                                : Icons.close,
                        color: textColor),
                  )),
            )
          ],
        ),
        showEmojiPicker
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      textController.text = textController.text + emoji.emoji;
                    });
                    if (!showIsSendbutton) {
                      setState(() {
                        showIsSendbutton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
