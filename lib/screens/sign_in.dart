import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futa_noise_app/forget_password.dart';
import 'package:futa_noise_app/screens/index_screen.dart';
import 'package:futa_noise_app/screens/signup_page.dart';
import 'package:futa_noise_app/Logic/toast.dart';
import 'package:futa_noise_app/Logic/Firebase/user_auth.dart';
import 'package:gap/gap.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signin_screen';
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigning = false;
  bool passwordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(120),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.multitrack_audio_sharp,
                        size: 70,
                        color: Color(0XFF1E319D),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "email",
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                                suffixIcon: const Icon(Icons.mail)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: passwordObscure,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintText: "password",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        passwordObscure = !passwordObscure;
                                      });
                                    },
                                  )),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: InkWell(
                          onTap: _signIn,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0XFF1E319D),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: double.infinity,
                            //height: 30,
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: _isSigning
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ForgetPassword.id);
                            },
                            child: const Text(
                              "Don't have an account ?",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, SignUp.id);
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 18, color: Color(0XFF1E319D)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully Logged In");
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, IndexScreen.id);
      //Helper.saveUserLoggedInSharePreference(true);
    } else {
      showToast(message: "Some error happend");
    }
  }
}
