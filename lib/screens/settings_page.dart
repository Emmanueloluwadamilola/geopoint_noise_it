import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/screens/sign_in.dart';
import 'package:futa_noise_app/Logic/toast.dart';
import 'package:gap/gap.dart';

class SettingPage extends StatefulWidget {
  static const String id = 'setting_page';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontFamily: black,
                fontSize: 30,
                color: Color(0xFF080713),
              ),
            ),
            const Gap(30),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, SignIn.id);
                showToast(message: "Successfully signed out");
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: kPrimaryColour,
                  ),
                  Gap(8),
                  Text(
                    "Sign Out",
                    style: TextStyle(
                      fontFamily: bold,
                      fontSize: 16,
                      color: kPrimaryColour,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, SignIn.id);
                showToast(message: "Successfully signed out");
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.info,
                    color: kPrimaryColour,
                  ),
                  Gap(8),
                  Text(
                    "About App",
                    style: TextStyle(
                        fontFamily: bold, fontSize: 16, color: kPrimaryColour),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
