// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:whatsapp_clone/model/status_model.dart';

final StatusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(stateRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void updateStatus(BuildContext context, File file) {
    ref.watch(AuthControllerProviderFuture).whenData((value) {
      statusRepository.updateStatus(
          context: context,
          profilePic: value!.profilePic,
          file: file,
          username: value.name,
          phone: value.phone);
    });
  }

  Future<List<StatusModel>> getUser(BuildContext context) async {
    var statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
