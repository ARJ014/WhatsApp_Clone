import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class OtpScreen extends ConsumerWidget {
  static const name = "/otpPage";
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});
  void validateOTP(
      WidgetRef ref, context, String verificationId, String usersms) async {
    ref
        .read(AuthControllerProvider)
        .verifyOTP(context, verificationId, usersms);
  }

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Verifying Your Phone Number"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 20),
          const Text("We have sent a SMS with a code"),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              onChanged: (value) {
                if (value.length == 6) {
                  print(value);
                  validateOTP(ref, context, verificationId, value);
                }
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 30), hintText: "- - - - - -"),
            ),
          )
        ]),
      ),
    );
  }
}
