// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widget/videoPlayer.dart';

class DisplayFile extends StatelessWidget {
  final String message;
  final MessageEnum type;

  bool isAudio = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  DisplayFile({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IconButton(
                        constraints: const BoxConstraints(minWidth: 100),
                        onPressed: () async {
                          if (isAudio) {
                            await _audioPlayer.pause();
                            setState(() {
                              isAudio = !isAudio;
                            });
                          } else {
                            await _audioPlayer.play(UrlSource(message));
                            setState(() {
                              isAudio = !isAudio;
                            });
                          }
                        },
                        icon: Icon((isAudio)
                            ? Icons.pause_circle
                            : Icons.play_circle)),
                  );
                },
              )
            : type == MessageEnum.video
                ? VideoPlayer(VideoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
