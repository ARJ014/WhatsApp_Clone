import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_page.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  void loginpage(context) {
    Navigator.pushNamed(context, LoginScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 30),
        const Text(
          "Welcome to whatsapp",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 33, color: textColor),
        ),
        SizedBox(height: size.height / 9),
        Image.asset("assets/bg.png", color: tabColor, height: 340, width: 340),
        SizedBox(height: size.height / 9),
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service',
              textAlign: TextAlign.center,
              style: TextStyle(color: subtextColor, fontSize: 14)),
        ),
        const SizedBox(height: 10),
        SizedBox(
            width: size.width * 0.75,
            child: Button(
                onpressed: () {
                  loginpage(context);
                },
                text: "Agree and Continue")),
      ])),
    );
  }
}
