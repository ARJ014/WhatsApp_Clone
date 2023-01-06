// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enum/message_enum.dart';
import 'package:whatsapp_clone/common/repository/firestorage_repo.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/model/chatContactModel.dart';
import 'package:whatsapp_clone/model/message.dart';
import 'package:whatsapp_clone/model/userModel.dart';

final ChatRepositoryProvider = Provider(((ref) => ChatRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        ChatContactModel chatContact =
            ChatContactModel.fromMap(document.data());
        print(chatContact);

        contacts.add(ChatContactModel(
            name: chatContact.name,
            profilePic: chatContact.profilePic,
            time: chatContact.time,
            lastmessage: chatContact.lastmessage,
            contactId: chatContact.contactId));
      }
      print("XXXXXXXXX:$contacts");
      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatMessages(String recieverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('timesent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        MessageModel message = MessageModel.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }

  void _savedataToContactSubcollection(
    userModel senderData,
    userModel recieverData,
    DateTime time,
    String recieverUserId,
    String text,
  ) async {
    var recieverChatContact = ChatContactModel(
        name: senderData.name,
        profilePic: senderData.profilePic,
        time: time,
        lastmessage: text,
        contactId: senderData.uid);

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(recieverChatContact.toMap());

    var senderChatContact = ChatContactModel(
        name: recieverData.name,
        profilePic: recieverData.profilePic,
        time: time,
        lastmessage: text,
        contactId: recieverData.uid);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveDataToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String recieverUsername,
    required String senderUsername,
    required MessageEnum messageType,
  }) async {
    final message = MessageModel(
        senderId: auth.currentUser!.uid,
        reciverId: recieverUserId,
        text: text,
        messageId: messageId,
        timesent: timeSent,
        type: messageType,
        isSeen: false);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextmessage(
      {required BuildContext context,
      required String text,
      required userModel senderUser,
      required String recieverUserId}) async {
    try {
      var timesent = DateTime.now();
      var userData =
          await firestore.collection('users').doc(recieverUserId).get();
      userModel receiverUSerData = userModel.fromMap(userData.data()!);
      var messageId = const Uuid().v1();
      _savedataToContactSubcollection(
          senderUser, receiverUSerData, timesent, recieverUserId, text);
      _saveDataToMessageSubcollection(
          recieverUserId: recieverUserId,
          text: text,
          timeSent: timesent,
          messageId: messageId,
          recieverUsername: receiverUSerData.name,
          messageType: MessageEnum.text,
          senderUsername: senderUser.name);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void sendFileMessage(context, ProviderRef ref, MessageEnum messageEnum,
      String recieverId, userModel senderUser, File file) async {
    try {
      userModel receiverUserData;

      var timesent = DateTime.now();
      var messageId = const Uuid().v1();

      String FileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToStorage(
              'chat/${messageEnum.type}/${senderUser.uid}/$recieverId/$messageId',
              file);

      var userData = await firestore.collection('users').doc(recieverId).get();
      receiverUserData = userModel.fromMap(userData.data()!);

      String contactMessage;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMessage = '📸 Photo';
          break;

        case MessageEnum.video:
          contactMessage = '🎬 Video';
          break;

        case MessageEnum.audio:
          contactMessage = "🔉 Audio";
          break;

        case MessageEnum.gif:
          contactMessage = "GIF";
          break;

        default:
          contactMessage = "GIF";
      }

      _savedataToContactSubcollection(
          senderUser, receiverUserData, timesent, recieverId, contactMessage);

      _saveDataToMessageSubcollection(
          recieverUserId: recieverId,
          text: FileUrl,
          timeSent: timesent,
          messageId: messageId,
          recieverUsername: receiverUserData.name,
          senderUsername: senderUser.name,
          messageType: messageEnum);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}