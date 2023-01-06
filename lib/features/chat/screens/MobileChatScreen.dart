// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/resources/colors.dart';
import 'package:whatsapp_clone/features/chat/widget/chat.dart';

import '../widget/chatTextField.dart';

class ChatScreenMobile extends ConsumerWidget {
  static const name = "/mobileChatScreen";
  final String username;
  final String uid;
  const ChatScreenMobile({
    Key? key,
    required this.username,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder(
          stream: ref.read(AuthControllerProvider).userData(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            return Column(
              children: [
                Text(username),
                Text(
                  snapshot.data!.isonline ? "online" : "offline",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w300),
                )
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call, color: Colors.grey)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.grey)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.grey))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: Expanded(
                  child: ChatScreen(
                receiverId: uid,
              )),
            ),
          ),
          chatTextField(
            recieverUserId: uid,
          )
        ],
      ),
    );
  }
}
