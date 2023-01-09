// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/firestorage_repo.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/model/status_model.dart';

final stateRepositoryProvider = Provider((ref) => StatusRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    ref: ref));

class StatusRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  StatusRepository({
    required this.auth,
    required this.firestore,
    required this.ref,
  });

  void updateStatus(
      {required BuildContext context,
      required String profilePic,
      required File file,
      required String username,
      required String phone}) async {
    try {
      List<Contact> contacts = [];
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToStorage('/status/$statusId/$uid', file);

      // if (await FlutterContacts.requestPermission()) {
      //   contacts = await FlutterContacts.getContacts(withProperties: true);
      // }

      List<String> whocansee = [];
      // for (int i = 0; i < contacts.length; i++) {
      //   var contact = await firestore
      //       .collection('users')
      //       .where('phone',
      //           isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
      //       .get();
      //   print(contact.docs[0].data());

      //   if (contact.docs.isNotEmpty) {
      //     var userData = userModel.fromMap(contact.docs[0].data());
      //     whocansee.add(userData.uid);
      //   }
      // }

      List<String> statusImageUrl = [];
      var snapshot = await firestore
          .collection('status')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await firestore.collection('status').doc(snapshot.docs[0].id).update({
          'photoUrl': FieldValue.arrayUnion([imageUrl])
        });

        return;
      } else {
        statusImageUrl.add(imageUrl);
      }

      StatusModel newStatus = StatusModel(
          uid: uid,
          username: username,
          photoUrl: statusImageUrl,
          profilePic: profilePic,
          createdAt: DateTime.now(),
          statusId: statusId,
          phone: phone,
          whoCanSee: whocansee);
      print(newStatus);

      await firestore.collection('status').doc(statusId).set(newStatus.toMap());
    } catch (e) {}
  }

  Future<List<StatusModel>> getStatus(context) async {
    List<StatusModel> statuses = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      print(contacts.length);

      var contact = await firestore.collection('status').get();
      for (var tempData in contact.docs) {
        print(StatusModel.fromSnap(tempData));
        // StatusModel tempStatus = StatusModel.fromMap(tempData.data());
        StatusModel tempStatus = StatusModel.fromSnap(tempData);

        statuses.add(tempStatus);
        if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {}
      }

      // if (snap.whoCanSee.contains(auth.currentUser!.uid)) {
      // }

    } catch (e) {
      showSnackbar(context, e.toString());
    }
    return statuses;
  }
}
