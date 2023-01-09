// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/calls/screens/call_Screen.dart';
import 'package:whatsapp_clone/model/call.dart';
import 'package:whatsapp_clone/model/group.dart';

final CallRepositoryProvider = Provider(((ref) {
  return CallRepository(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance);
}));

class CallRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  CallRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  Stream<DocumentSnapshot> get callStream => firebaseFirestore
      .collection('calls')
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots();

  void makeCall(
      {required BuildContext context,
      required Call senderData,
      required Call recieverData}) async {
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderData.callerId)
          .set(senderData.toMap());

      await firebaseFirestore
          .collection('calls')
          .doc(senderData.recieverId)
          .set(recieverData.toMap());

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderData.callId,
                  call: senderData,
                  isGroupChat: false)));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void makeGroupCall(
      {required BuildContext context,
      required Call senderData,
      required Call recieverData}) async {
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderData.callerId)
          .set(senderData.toMap());

      var groupSnapshot = await firebaseFirestore
          .collection('groups')
          .doc(senderData.recieverId)
          .get();
      GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);
      for (var id in group.memeberUid) {
        await firebaseFirestore
            .collection('calls')
            .doc(id)
            .set(recieverData.toMap());
      }

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                  channelId: senderData.callId,
                  call: senderData,
                  isGroupChat: true)));
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void endCall(
    context,
    String senderId,
    String reciverId,
  ) async {
    await firebaseFirestore.collection('calls').doc(senderId).delete();
    await firebaseFirestore.collection('calls').doc(reciverId).delete();
  }

  void endGroupCall(
    context,
    String senderId,
    String reciverId,
  ) async {
    await firebaseFirestore.collection('calls').doc(senderId).delete();
    var Groupsnapshot =
        await firebaseFirestore.collection('groups').doc(reciverId).get();
    GroupModel group = GroupModel.fromMap(Groupsnapshot.data()!);
    for (var id in group.memeberUid) {
      await firebaseFirestore.collection('calls').doc(id).delete();
    }
  }
}
