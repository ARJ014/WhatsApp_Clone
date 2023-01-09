import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/phone_contacts/screens/selectContactScreen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_Statues_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_contact_screen.dart';
import 'package:whatsapp_clone/resources/colors.dart';
import 'package:whatsapp_clone/features/chat/widget/contactCard.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController _tabController;

  final icons = [Icons.message, Icons.camera, Icons.call];
  IconData floating = Icons.message;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    setState(() {
      floating = icons[_tabController.index];
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(AuthControllerProvider).setUserState(true);
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.watch(AuthControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            "MessageApp",
            style: TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: tabColor,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "CHATS"),
              Tab(text: "STATUS"),
              Tab(text: "CALLS")
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ContactCard(),
            StatusContactScreen(),
            Text("calls"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_tabController.index == 0) {
              Navigator.pushNamed(context, ContactScreen.name);
            } else {
              File? file = await pickImageFromGallery(context);
              if (file != null) {
                Navigator.pushNamed(
                  context,
                  ConfirmStatusScreen.name,
                  arguments: file,
                );
              }
            }
          },
          backgroundColor: tabColor,
          child: Icon(
            floating,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
