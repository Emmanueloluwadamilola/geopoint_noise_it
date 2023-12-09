import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futa_noise_app/home_screen.dart';
import 'package:futa_noise_app/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/toast.dart';

import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        showToast(message: 'User is currently Signed out.');
      } else {
        showToast(message: 'User is Signed in.');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Get.to(() => FirebaseAuth.instance.currentUser == null? const SignIn(): const HomePage());
    });
    return Scaffold(
      body: Container(
        color: const Color(0XFF1E319D),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.multitrack_audio_sharp,
                size: 90,
                color: Colors.white,
              ),
              Text(
                "Noise it",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
