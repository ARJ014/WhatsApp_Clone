import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/MobileChatScreen.dart';
import 'package:whatsapp_clone/model/chatContactModel.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class ContactCard extends ConsumerWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContactModel>>(
          stream: ref.watch(ChatControllerProvider).getchatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            print(snapshot.data);
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  ChatContactModel contact = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, ChatScreenMobile.name,
                                arguments: {
                                  'name': contact.name,
                                  'uid': contact.contactId
                                });
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>  ChatScreenMobile()));
                          },
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   radius: 30,
                            //   backgroundImage: NetworkImage(contact.profilePic),
                            // ),
                            leading: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                  imageUrl: contact.profilePic),
                            ),
                            title: Text(
                              contact.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                contact.lastmessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            trailing: Text(DateFormat.Hm().format(contact.time),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ),
                        ),
                        const Divider(
                          color: dividerColor,
                          indent: 85,
                        )
                      ],
                    ),
                  );
                }));
          }),
    );
  }
}
