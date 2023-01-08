// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/provider/messageReply.dart';
import 'package:whatsapp_clone/features/chat/widget/diplay_file.dart';

class MesssgeReplyPreview extends ConsumerWidget {
  final String receiver;

  const MesssgeReplyPreview({
    required this.receiver,
  });

  void cancelMessageReply(WidgetRef ref) {
    ref.read(MessageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, ref) {
    final messagereply = ref.watch(MessageReplyProvider);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          )),
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  messagereply!.isMe ? "Me" : receiver,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                GestureDetector(
                  onTap: () {
                    cancelMessageReply(ref);
                  },
                  child: const Icon(Icons.close, size: 16),
                )
              ],
            ),
            const SizedBox(height: 8),
            DisplayFile(
                message: messagereply.message, type: messagereply.messageType)
          ],
        ),
      ),
    );
  }
}
