// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/calls/repository/call_repostiory.dart';
import 'package:whatsapp_clone/model/call.dart';

final CallControllerProvider = Provider((ref) {
  final callRepository = ref.read(CallRepositoryProvider);
  return CallController(
      callRepository: callRepository, ref: ref, auth: FirebaseAuth.instance);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall({
    required BuildContext context,
    required String recieverName,
    required String recieverId,
    required String recieverPic,
    required bool isGroupChat,
  }) {
    ref.read(AuthControllerProviderFuture).whenData((value) {
      final callId = const Uuid().v1();
      Call senderCall = Call(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          hasDialed: true,
          callId: callId);

      Call recieverCall = Call(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          recieverId: recieverId,
          recieverName: recieverName,
          recieverPic: recieverPic,
          hasDialed: false,
          callId: callId);

      if (isGroupChat) {
        callRepository.makeGroupCall(
            context: context,
            senderData: senderCall,
            recieverData: recieverCall);
      } else {
        callRepository.makeCall(
            context: context,
            senderData: senderCall,
            recieverData: recieverCall);
      }
    });
  }

  void endCall(context, String senderId, String reciverId) {
    callRepository.endCall(context, senderId, reciverId);
  }
}
