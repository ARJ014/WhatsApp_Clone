// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String VideoUrl;
  const VideoPlayer({
    Key? key,
    required this.VideoUrl,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isPlay = false;
  late CachedVideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.VideoUrl)
      ..initialize().then((value) => videoController.setVolume(0.5));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(children: [
        CachedVideoPlayer(videoController),
        Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  if (isPlay) {
                    videoController.pause();
                  } else {
                    videoController.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
                icon: isPlay
                    ? const Icon(Icons.play_arrow)
                    : const Icon(
                        Icons.pause,
                        color: Colors.white38,
                      )))
      ]),
    );
  }
}
