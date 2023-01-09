// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/firestorage_repo.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/model/group.dart';

final GroupRepositoryProvider = Provider(((ref) => GroupRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref)));

class GroupRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  GroupRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  void createGroup(
      {required BuildContext context,
      required String groupName,
      required File groupPic,
      required List<Contact> selectedContacts}) async {
    try {
      List uids = [];

      for (int i = 0; i < selectedContacts.length; i++) {
        var contact = await firestore
            .collection('users')
            .where('phone',
                isEqualTo:
                    selectedContacts[i].phones[0].number.replaceAll(" ", ''))
            .get();
        if (contact.docs.isNotEmpty && contact.docs[0].exists) {
          uids.add(contact.docs[0].data()['uid']);
        }
      }

      var groupId = const Uuid().v1();
      String groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToStorage("group/$groupId", groupPic);

      GroupModel group = GroupModel(
          senderId: auth.currentUser!.uid,
          name: groupName,
          groupId: groupId,
          lastmessage: '',
          groupPic: groupPicUrl,
          time: DateTime.now(),
          memeberUid: [auth.currentUser!.uid, ...uids]);

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
