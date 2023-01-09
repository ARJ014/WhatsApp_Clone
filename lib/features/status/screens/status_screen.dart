// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';

import 'package:whatsapp_clone/model/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const name = "/StatusScreen";
  final StatusModel status;

  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItem = [];

  @override
  void initState() {
    super.initState();
    storyItems();
  }

  void storyItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItem.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItem.isEmpty
          ? const LoadingScreen()
          : StoryView(
              storyItems: storyItem,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
