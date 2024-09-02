import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/screens/index_screen.dart';
import 'package:futa_noise_app/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/Logic/toast.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
      Get.to(() => FirebaseAuth.instance.currentUser == null
          ? const SignIn()
          : const IndexScreen());
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                      kPrimaryColour,
                      BlendMode.modulate,
                    ),
                child: Lottie.asset(
                    
                    'assets/lottie/noise.json'),
              ),
            ),
            const Text(
              "Noise App",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color:  Color(0XFF0005ff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
