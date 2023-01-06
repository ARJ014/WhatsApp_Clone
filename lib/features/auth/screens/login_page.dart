import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/common/widgets/button.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const name = "/LoginPage";
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? _country;

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: ((value) => setState(
            () {
              _country = value;
            },
          )),
    );
  }

  void sendPhoneNumber() {
    String phone = phoneController.text.trim();
    if (_country != null && phone.isNotEmpty) {
      ref
          .read(AuthControllerProvider)
          .signInwithPhone(context, "+${_country!.phoneCode}$phone");
    } else {
      showSnackbar(context, "Please fill out all the fields");
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text("Enter your phone number"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Whatsapp will need to verify your phone number",
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    pickCountry();
                  },
                  child: const Text("Pick country")),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    if (_country != null) Text("+${_country!.phoneCode}"),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                              hintText: "enter phone number"),
                        ))
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.65),
              SizedBox(
                  width: 80,
                  child: Button(
                      onpressed: () {
                        sendPhoneNumber();
                      },
                      text: "Next")),
            ],
          ),
        ),
      ),
    );
  }
}
