// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/calls/controller/call_controller.dart';
import 'package:whatsapp_clone/features/calls/screens/call_accept.dart';
import 'package:whatsapp_clone/features/chat/widget/chat.dart';
import 'package:whatsapp_clone/resources/colors.dart';

import '../widget/chatTextField.dart';

class ChatScreenMobile extends ConsumerWidget {
  static const name = "/mobileChatScreen";
  final String username;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const ChatScreenMobile({
    Key? key,
    required this.username,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref, context) {
    ref.read(CallControllerProvider).makeCall(
        context: context,
        recieverName: username,
        recieverId: uid,
        recieverPic: profilePic,
        isGroupChat: isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallAcceptScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(username)
              : StreamBuilder(
                  stream: ref.read(AuthControllerProvider).userData(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null) {
                      return const LoadingScreen();
                    }
                    return Column(
                      children: [
                        Text(username),
                        snapshot.data!.isonline
                            ? const Text("online",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300))
                            : const SizedBox()
                      ],
                    );
                  },
                ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: (() => makeCall(ref, context)),
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
                  isGroupChat: isGroupChat,
                )),
              ),
            ),
            chatTextField(
              recieverUserId: uid,
              reciever: username,
              isGroupChat: isGroupChat,
            )
          ],
        ),
      ),
    );
  }
}
