import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/resources/colors.dart';
import 'package:whatsapp_clone/route.dart';
import 'package:whatsapp_clone/screens/mobileScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyCkAo2eW2j99gXyKGqSZkxLakW5bgFd2g4",
      appId: "1:296010813173:web:41232cf9053890312a3fbc",
      messagingSenderId: "296010813173",
      projectId: "whatsappbackend-9fe0b",
      storageBucket: "whatsappbackend-9fe0b.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MessageApp',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(AuthControllerProviderFuture).when(
            data: (data) {
              if (data != null) {
                return const MobileScreenLayout();
              } else {
                return const LandingPage();
              }
            },
            error: (e, trace) {
              return ErrorScreen(error: e.toString());
            },
            loading: () => const LoadingScreen(),
          ),
    );
  }
}
