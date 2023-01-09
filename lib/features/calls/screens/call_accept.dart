// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/calls/controller/call_controller.dart';
import 'package:whatsapp_clone/model/call.dart';

import 'call_Screen.dart';

class CallAcceptScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallAcceptScreen({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(CallControllerProvider).callStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Call call =
                Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDialed) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Incoming Call",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 50),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 60,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 25),
                      ),
                      const SizedBox(height: 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                ref.read(CallControllerProvider).endCall(
                                    context, call.callerId, call.recieverId);
                              },
                              icon: const Icon(
                                Icons.call_end,
                                color: Colors.redAccent,
                              )),
                          const SizedBox(width: 25),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CallScreen(
                                            channelId: call.callId,
                                            call: call,
                                            isGroupChat: false)));
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }
          return scaffold;
        }));
  }
}
