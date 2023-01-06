// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/phone_contacts/repository/phone_contacts_repo.dart';

final SelectContactControllerProvider = FutureProvider((ref) {
  final selectContactRepostitory = ref.watch(SelectContactRepostitoryProvider);
  return selectContactRepostitory.getContacts();
});

final onSelectContactControllerProvider = Provider((ref) {
  final selectContactRepostitory = ref.read(SelectContactRepostitoryProvider);
  return SelectContactController(
      selectContact: selectContactRepostitory, ref: ref);
});

class SelectContactController {
  final SelectContactRepostitory selectContact;
  final ProviderRef ref;

  SelectContactController({
    required this.selectContact,
    required this.ref,
  });

  void onSelectContact(context, Contact selectedContact) {
    selectContact.selectContact(context, selectedContact);
  }
}
