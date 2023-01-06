import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/auth/repository/authRepsitory.dart';
import 'package:whatsapp_clone/model/userModel.dart';

final AuthControllerProvider = Provider(((ref) {
  final authRepository = ref.watch(AuthRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
}));

final AuthControllerProviderFuture = FutureProvider(((ref) {
  final authcontroller = ref.watch(AuthControllerProvider);
  return authcontroller.getCurrentUser();
}));

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.authRepository, required this.ref});

  Future<userModel?> getCurrentUser() async {
    userModel? user = await authRepository.getCurrentUser();
    return user;
  }

  void signInwithPhone(context, String Phone) {
    authRepository.signInWithPhone(context, Phone);
  }

  void verifyOTP(context, String verificationId, String userOtp) {
    authRepository.verifyOTP(
        context: context, verificationID: verificationId, sms: userOtp);
  }

  void saveUserDataToFirebase(context, String username, File? profile) {
    authRepository.uploadToFirebase(
        username: username, profile: profile, ref: ref, context: context);
  }

  Stream<userModel> userData(String uid) {
    return authRepository.userData(uid);
  }

  void setUserState(bool isOnline) async {
    authRepository.setUserState(isOnline);
  }
}
