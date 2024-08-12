import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../app/app_routes.dart';
import '../core/navigation_service.dart';
import '../core/overlay_service.dart';
import '../core/utils.dart';
import '../entities/user_data.dart';
import 'user_repo.dart';

class AuthController extends ChangeNotifier {
  late UserData user;

  final auth = FirebaseAuth.instance;
  final repo = UserRepo.instance;
  final overlay = OverlayService.instance;
  final nav = NavigationService.instance;

  AuthController();

  void continueWithGoogle() {
    handleErrors(
      () async {
        nav.showLoadingIndicator(true);
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final credits = await auth.signInWithCredential(credential);
        final userData = UserData.fromFirebaseUser(credits.user!);
        this.user = await repo.addUserIfNew(userData);
        await updateIpAddress();
        nav.replaceAll(AppRoutes.home);
      },
      onError: () {
        nav.pop();
        GoogleSignIn().signOut();
      },
    );
  }

  void logout() {
    handleErrors(
      () async {
        nav.showLoadingIndicator(true);
        await repo.updateIdAddress(user.uid, '');
        await auth.signOut();
        nav.replace(AppRoutes.initial);
      },
      onError: nav.pop,
    );
  }

  void redirectNavigation() {
    handleErrors(
      () async {
        final user = auth.currentUser;
        if (user == null) {
          nav.replace(AppRoutes.initial);
          return;
        }
        this.user = await repo.getUser(user.uid);
        await updateIpAddress();
        nav.replaceAll(AppRoutes.home);
      },
      onError: () {
        nav.replace(AppRoutes.initial);
      },
    );
  }

  Future<void> updateIpAddress() async {
    String? localIpAddress = await NetworkInfo().getWifiIP();
    localIpAddress ??= '';
    this.user = this.user.copyWith(ipAddress: localIpAddress);
    await repo.updateIdAddress(user.uid, localIpAddress);
  }
}
