import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/groups/controller/group_controller.dart';
import 'package:whatsapp_clone/features/groups/widget/group_contact_card.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const name = "/CreateGroupScreen";
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  void selectImage(context) async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(GroupControllerProvider).createGroup(
          context,
          groupNameController.text.trim(),
          image!,
          ref.read(GropupContactSelectProvider));
      ref.read(GropupContactSelectProvider.state).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Column(children: [
        const SizedBox(height: 10),
        Stack(
          children: [
            (image == null)
                ? const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png'),
                    radius: 60,
                  )
                : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 60,
                  ),
            Positioned(
              bottom: -10,
              left: 75,
              child: IconButton(
                  onPressed: () {
                    selectImage(context);
                  },
                  icon: const Icon(Icons.add_a_photo)),
            )
          ],
        ),
        Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.all(15),
          child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(hintText: "Enter Group name")),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8),
          child: const Text(
            'Select Contacts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const GropupContactSelect(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(Icons.done),
      ),
    );
  }
}
