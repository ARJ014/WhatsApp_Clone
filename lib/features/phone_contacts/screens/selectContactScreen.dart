import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/phone_contacts/controller/phone_controller.dart';

class ContactScreen extends ConsumerWidget {
  static const name = "/contactScreen";
  const ContactScreen({super.key});

  void selectContact(context, WidgetRef ref, Contact phone) {
    ref.read(onSelectContactControllerProvider).onSelectContact(context, phone);
  }

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contacts "),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: ref.watch(SelectContactControllerProvider).when(
            data: (contacts) {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return InkWell(
                    onTap: () {
                      selectContact(context, ref, contact);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 24),
                        ),
                        leading: (contact.photo == null)
                            ? null
                            : CircleAvatar(
                                radius: 30,
                                backgroundImage: MemoryImage(contact.photo!),
                              ),
                      ),
                    ),
                  );
                },
              );
            },
            error: ((error, stackTrace) =>
                ErrorScreen(error: error.toString())),
            loading: () => const LoadingScreen()));
  }
}
