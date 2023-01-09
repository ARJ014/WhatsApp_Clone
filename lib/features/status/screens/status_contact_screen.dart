import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/state_controller.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/model/status_model.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class StatusContactScreen extends ConsumerWidget {
  const StatusContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(StatusControllerProvider).getUser(context),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        print(snapshot.data);
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: ((context, index) {
            var status = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, StatusScreen.name,
                        arguments: status);
                  },
                  child: ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CachedNetworkImage(imageUrl: status.profilePic),
                    ),
                    title: Text(
                      status.username,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(DateFormat.Hm().format(status.createdAt),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey)),
                  ),
                ),
                const Divider(
                  color: dividerColor,
                  indent: 85,
                )
              ],
            );
          }),
        );
      }),
    );
  }
}
