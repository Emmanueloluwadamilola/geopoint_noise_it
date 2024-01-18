import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/forget_password.dart';
import 'package:futa_noise_app/home_screen.dart';
import 'package:futa_noise_app/list_page.dart';
import 'package:futa_noise_app/map_page.dart';
import 'package:futa_noise_app/search_page.dart';
import 'package:futa_noise_app/settings_page.dart';
import 'package:futa_noise_app/sign_in.dart';
import 'package:futa_noise_app/signup_page.dart';
import 'package:futa_noise_app/welcome_page.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FUTA Noise App',
        theme: ThemeData(
          useMaterial3: true,
        ),
        initialRoute: WelcomePage.id,
        routes: {
          WelcomePage.id: (context) => const WelcomePage(),
          SignIn.id: (context) => const SignIn(),
          SignUp.id: (context) => const SignUp(),
          HomePage.id: (context) => const HomePage(),
          ForgetPassword.id: (context) => const ForgetPassword(),
          SettingPage.id: (context) => const SettingPage(),
          SearchPage.id: (context) => const SearchPage(),
          ListPage.id: (context) =>  const ListPage(),
          NoiseMapScreen.id: (context) =>  NoiseMapScreen(),

        });
  }
}
