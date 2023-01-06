import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/repository/firestorage_repo.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/userinformation.dart';
import 'package:whatsapp_clone/model/userModel.dart';
import 'package:whatsapp_clone/screens/mobileScreen.dart';

// Provider
final AuthRepositoryProvider = Provider(((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance)));

// Defining the authentication methods class
class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});

  Future<userModel?> getCurrentUser() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    userModel? user;
    if (userData.data() != null) {
      user = userModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(context, String phone) async {
    try {
      if (kIsWeb) {
        ConfirmationResult confirmationResult =
            await auth.signInWithPhoneNumber(phone);
        Navigator.pushNamed(context, OtpScreen.name,
            arguments: confirmationResult.verificationId);
      }
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: ((error) {
          throw Exception(error.message);
        }),
        codeSent: ((String verificationId, int? resendToken) {
          Navigator.pushNamed(context, OtpScreen.name,
              arguments: verificationId);
        }),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void verifyOTP(
      {required context,
      required String verificationID,
      required String sms}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: sms);
      await auth.signInWithCredential(credential);

      Navigator.pushNamedAndRemoveUntil(
          context, UserInfoScreen.name, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void uploadToFirebase(
      {required String username,
      required File? profile,
      required ProviderRef ref,
      required context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIoAAACKCAMAAABCWSJWAAAAZlBMVEX///8AAACqqqrv7+/8/Py5ubn5+fn29vba2tolJSXg4ODy8vLCwsILCwtycnLn5+eIiIixsbEYGBhUVFQ/Pz8uLi54eHhPT0/R0dEfHx9nZ2ekpKTJyclHR0eVlZU0NDRdXV2AgIC/bEkpAAAEZklEQVR4nO1a25aqMAwduckdARFERfj/nzy6xqZFBEKbOueh+3GmDds0SXPpz4+BgYGBgYGBgYGBwf8GL4zdPHdjf/+nLPw4LZLdC0nRur73J0TsSwk0gE55sb9OxB/eaTAM/leJ2OlEIYJq2i9qxgrmiTwRXL5ExC6XiTxRZt9g0hzXmex29+YLTDBEnrjqZuK+ffCWdvnV969ul97e/pXrZXIdfSwYfMFZbP8wNudYJ5NM/FJlTWKrY93FFaE+JrZ4Bt3HS2ffCRHnqC/AnPhXzrNW2QinlOpiIphsuXAPe7120/XOnMnySs6l0HNVd9yDV3ITr+YWpYNJBkoJVrMkDxyp0OFFXCmIeHHVqhZQCsotBrY6obeWmMmuUJduBkfkklOBn3nArYfzPFEz2cPhR7gNHmygLgV8JrjF7kjZDurM5bL56CE2U/tQ+5J7RseJLNiqRxwcls8e8XtY4lk6pFRsJrfH72GKvNOm3GH1kjvg9xxeWwLa2O+zWLvBBpmlF7Tlol+85Fr4Pa5mKhvqvlwTFYkD6vRQgdttQ7bKMuGK1mz3LNev8XsgFBHn/Uxuhb7cHKZI4hDH6w50Kdywgog6S4DLDe1CFtuxwf9RgBI1wO6ANI661eJBjYpMP6D5cSRPbiFBRN75kDkhE9ANgDQO16vg1YeG9hNUfBXGOcFSbvRMhOIdoXJev+ko4L0SL57TrrW0/qEoW41zTQErNTXBWs5l0RaFJiZxig3gvYTFM8r5qkJbJ1n4yO4040fOICyijvkCDsJnio+KycV+KX10E1ALH9rd3bdMxI5HTXcdIYUjGjf4g4Gzsd1DNfrnXfMsxpmOPar+dOrvkz/XxBnTFF49+ehH6IltYzjdOo+HxX5noBmvM6Hven3EtV8YHP4iKWPtlvJQCWpI9jBmrSOYB5p+nQRDqXVmd1knIKLTdkrh3NkEc8Peu6bxdzyx1qoerCbL7AeyrLGGupqQ0TKFmYSTQzxJAbL4MFlFTsRJx19IZyNH/LayJw67UStKT9rFPkU4frFA/ERhdAn2q8YYjphTJgt7MZocUUF9FAkJz2gQxJZIdduiYsj6GqLvbGgLivGQyI/E4f+mi0V64xyiSlrglXtSQOFG3GSTzfdbyMtEAjdypXXyhHBGyleAMHKXqq94FZcgJ32z4HeKpBNw91P06BCUcpQMU7yJp9hg51ebtJwQRCi1FfgrHoUYxY9IpdkPUiqFsADDPpXZagRhQckTeTyQ/0FchgoT4WWF/C+CQKv4JhLa/b2shJAl8rjHGfOIWJ/hLOuHcD7KzT0Y4cie0MAEKD+HhJ6l7Os0tl/9gocTkrT/SPWnCAAFy/0qaKMQvCne/uZkBAi1BIUvXERyFwiYPUU/gMmSyhQcVj0kBEwg4LYyPbqItSI3TLnnwQK31Pw7Y5k+yfSCJT6BTOCGOQdJaccSU6lZCKRNJJUduKNM+hRZv7iQdPf8y0ucat5vYGBgYGBgYGBgYLAB/wAozyxlWNtgYgAAAABJRU5ErkJggg==';
      if (profile != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeToStorage("/Profile_Pics/$uid", profile);
      }

      userModel user = userModel(
          name: username,
          uid: uid,
          profilePic: photoUrl,
          phone: auth.currentUser!.phoneNumber!,
          groupId: [],
          isonline: true);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => const MobileScreenLayout())),
          (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Stream<userModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => userModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isonline': isOnline});
  }
}
