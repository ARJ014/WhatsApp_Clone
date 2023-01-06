// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/model/userModel.dart';
import 'package:whatsapp_clone/features/chat/screens/MobileChatScreen.dart';

final SelectContactRepostitoryProvider = Provider(
  (ref) {
    return SelectContactRepostitory(firestore: FirebaseFirestore.instance);
  },
);

class SelectContactRepostitory {
  final FirebaseFirestore firestore;

  SelectContactRepostitory({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(context, Contact selectedContact) async {
    try {
      bool isfound = false;
      var users = await firestore.collection('users').get();
      String selectedPhone =
          selectedContact.phones[0].number.replaceAll(' ', '');
      for (var document in users.docs) {
        var userData = userModel.fromMap(document.data());
        if (userData.phone == selectedPhone) {
          isfound = true;
          Navigator.pushNamed(context, ChatScreenMobile.name, arguments: {
            "name": userData.name,
            "uid": userData.uid,
          });
        }
      }
      if (!isfound) {
        showSnackbar(context, "This number was not found in this app");
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
