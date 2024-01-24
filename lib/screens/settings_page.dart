import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/screens/sign_in.dart';
import 'package:futa_noise_app/Logic/toast.dart';

class SettingPage extends StatefulWidget {
  static const String id = 'setting_page';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Setting",
            style: TextStyle(color: Color(0XFF1E319D)),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () {
                //Helper.saveUserLoggedInSharePreference(false);
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, SignIn.id);
                showToast(message: "Successfully signed out");
              },
            ),
             ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About App"),
              onTap: (){
                
              },
            )
          ],
        ));
  }
}
