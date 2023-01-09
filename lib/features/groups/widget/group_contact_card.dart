import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/phone_contacts/controller/phone_controller.dart';
import 'package:whatsapp_clone/resources/colors.dart';

final GropupContactSelectProvider = StateProvider<List<Contact>>(((ref) => []));

class GropupContactSelect extends ConsumerStatefulWidget {
  const GropupContactSelect({super.key});

  @override
  ConsumerState<GropupContactSelect> createState() =>
      _GropupContactSelectState();
}

class _GropupContactSelectState extends ConsumerState<GropupContactSelect> {
  List groupIndex = [];
  void addGroupContacts(Contact phone, int index) {
    if (groupIndex.contains(index)) {
      groupIndex.remove(index);
    } else {
      groupIndex.add(index);
    }
    setState(() {});
    ref
        .read(GropupContactSelectProvider.state)
        .update((state) => [...state, phone]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(SelectContactControllerProvider).when(
        data: (data) {
          return Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                final contact = data[index];

                return InkWell(
                  onTap: (() => addGroupContacts(data[index], index)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: (contact.photo == null)
                          ? null
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(contact.photo!),
                            ),
                      trailing: (groupIndex.contains(index))
                          ? const Icon(Icons.done_sharp)
                          : null,
                      textColor: (groupIndex.contains(index))
                          ? Colors.blue
                          : textColor,
                    ),
                  ),
                );
              }),
            ),
          );
        },
        error: ((error, stackTrace) => ErrorScreen(error: error.toString())),
        loading: (() => (const LoadingScreen())));
  }
}
