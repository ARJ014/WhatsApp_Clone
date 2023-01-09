// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/groups/repository/group_repsotitory.dart';

final GroupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(GroupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController {
  final GroupRepository groupRepository;
  ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(context, String groupName, File groupPic,
      List<Contact> selectedContacts) {
    groupRepository.createGroup(
        context: context,
        groupName: groupName,
        groupPic: groupPic,
        selectedContacts: selectedContacts);
  }
}
