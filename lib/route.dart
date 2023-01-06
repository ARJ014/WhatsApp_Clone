import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';

import 'package:whatsapp_clone/features/auth/screens/login_page.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/userinformation.dart';
import 'package:whatsapp_clone/features/phone_contacts/screens/selectContactScreen.dart';
import 'package:whatsapp_clone/features/chat/screens/MobileChatScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case (LoginScreen.name):
      return MaterialPageRoute(builder: ((context) => const LoginScreen()));

    case (OtpScreen.name):
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: ((context) => OtpScreen(
                verificationId: verificationId,
              )));

    case (UserInfoScreen.name):
      return MaterialPageRoute(builder: ((context) => const UserInfoScreen()));

    case (ContactScreen.name):
      return MaterialPageRoute(builder: ((context) => const ContactScreen()));

    case (ChatScreenMobile.name):
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: ((context) => ChatScreenMobile(
                username: name,
                uid: uid,
              )));

    default:
      return MaterialPageRoute(
          builder: ((context) => const Scaffold(
              body: ErrorScreen(error: "This page does not exist"))));
  }
}
