import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/forget_password.dart';
import 'package:futa_noise_app/screens/home_screen.dart';
import 'package:futa_noise_app/screens/list_page.dart';
import 'package:futa_noise_app/screens/map_screen.dart';
import 'package:futa_noise_app/screens/search_page.dart';
import 'package:futa_noise_app/screens/settings_page.dart';
import 'package:futa_noise_app/screens/sign_in.dart';
import 'package:futa_noise_app/screens/signup_page.dart';
import 'package:futa_noise_app/screens/welcome_page.dart';
import 'package:get/get.dart';
import 'Logic/Firebase/firebase_options.dart';

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
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        initialRoute: WelcomePage.id,
        routes: {
          WelcomePage.id: (context) => const WelcomePage(),
          SignIn.id: (context) => const SignIn(),
          SignUp.id: (context) => const SignUp(),
          Home.id: (context) => const Home(),
          ForgetPassword.id: (context) => const ForgetPassword(),
          SettingPage.id: (context) => const SettingPage(),
          SearchPage.id: (context) => const SearchPage(),
          ListPage.id: (context) => const ListPage(),
          MapScreen.id: (context) =>  const MapScreen(),
        });
  }
}
