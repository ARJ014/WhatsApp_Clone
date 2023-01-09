import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const name = "/user_info_screen";
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage(context) async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(AuthControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
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
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: "Enter your name")),
                ),
                IconButton(
                    onPressed: () {
                      saveUserData();
                    },
                    icon: const Icon(Icons.done))
              ],
            )
          ],
        ),
      )),
    );
  }
}
