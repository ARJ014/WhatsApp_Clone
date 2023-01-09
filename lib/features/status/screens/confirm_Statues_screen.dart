// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/status/controller/state_controller.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const name = "/ConfirmStatusScreen";
  final File file;

  const ConfirmStatusScreen({
    required this.file,
  });

  void addStatus(context, WidgetRef ref) {
    ref.read(StatusControllerProvider).updateStatus(context, file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(file),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () {
          addStatus(context, ref);
        },
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
